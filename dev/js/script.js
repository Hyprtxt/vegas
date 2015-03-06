(function() {
  var calculateAge;

  console.log('script.coffee');

  if (window.Storage && window.JSON) {
    window.storage = function(key) {
      return {
        set: function(value) {
          return localStorage.setItem(key, JSON.stringify(value));
        },
        get: function() {
          var item;
          item = localStorage.getItem(key);
          if (item) {
            return JSON.parse(item);
          }
        }
      };
    };
  }

  if (!Date.now) {
    Date.now = function() {
      return new Date().getTime();
    };
  }

  window.getParameterByName = function(name) {
    var regex, results;
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
    results = regex.exec(location.search);
    if (results === null) {
      return '';
    } else {
      return decodeURIComponent(results[1].replace(/\+/g, ' '));
    }
  };

  window.setPlayerValue = function(name, value) {
    $('span.' + name).text(value);
    return $("input[name='" + name + "']").val(value);
  };

  calculateAge = function(date, birthday) {
    var ageDate, ageDifMs;
    ageDifMs = date.getTime() - birthday.getTime();
    ageDate = new Date(ageDifMs);
    return Math.abs(ageDate.getUTCFullYear() - 1970);
  };

  window.ClubCard = function(options) {
    this.opts = options || {};
    return this;
  };

  window.Player = function(options) {
    this.opts = options || {};
    this.opts.name = options.name || '';
    this.opts.mood = options.mood || '';
    this.opts.cash = options.cash || 0;
    this.opts.spend = options.spend || 0;
    this.opts.hands = options.hands || 0;
    this.opts.speed = options.speed || 1.0;
    this.opts.hunger = options.hunger || 10;
    this.opts.stamina = options.stamina || 20;
    this.opts.location = options.location || '';
    this.opts.birthDay = options.birthDay || 21;
    this.opts.birthYear = options.birthYear || 1987;
    this.opts.birthMonth = options.birthMonth || 7;
    this.opts.inventory = options.inventory || [];
    this.opts.playerRetireDate = options.playerRetireDate || new Date().now();
    this.opts.playerDay = options.playerDay || 0;
    this.opts.playerHour = options.playerHour || 9;
    return this;
  };

  Player.prototype.updateDynamic = function(key, val) {
    return $('.' + key).text(val);
  };

  Player.prototype.updateStatic = function(key) {
    $('.' + key).text(this.opts[key]);
    return true;
  };

  Player.prototype.update = function() {
    this.updateStatic('name');
    this.updateStatic('mood');
    this.updateDynamic('age', this.age());
    this.updateDynamic('date', this.date());
    this.updateDynamic('time', this.time());
    this.updateStatic('location');
    this.updateStatic('cash');
    this.updateStatic('stamina');
    this.updateStatic('hunger');
    this.updateStatic('spend');
    this.updateStatic('hands');
    this.updateStatic('speed');
    this.updateStatic('playerDay');
    this.updateDynamic('handsPerHour', this.handsPerHour());
    this.updateDynamic('speedMod', this.speedMod());
    return true;
  };

  Player.prototype.speedMod = function() {
    if (this.opts.hands > 1000000) {
      return 3;
    }
    if (this.opts.hands > 100000) {
      return (Math.round(this.opts.hands / 1000) / 1000) + 2;
    } else {
      return (Math.round(this.opts.hands / 100) / 1000) + 1;
    }
  };

  Player.prototype.handsPerHour = function() {
    return Math.floor(this.speedMod() * 300);
  };

  Player.prototype.get = function(key) {
    return this.opts[key];
  };

  Player.prototype.set = function(key, val) {
    this.opts[key] = val;
    this.updateDynamic(key, val);
    return true;
  };

  Player.prototype.save = function() {
    storage('Vegas').set(this.opts);
    return true;
  };

  Player.prototype.birthDayDate = function() {
    return new Date(this.opts.birthYear, this.opts.birthMonth, this.opts.birthDay);
  };

  Player.prototype.todayDate = function() {
    var date, days, hours;
    days = this.opts.playerDay * 86400000;
    hours = this.opts.playerHour * 3600000;
    date = new Date(this.opts.playerRetireDate + days + hours);
    return date;
  };

  Player.prototype.age = function() {
    return calculateAge(this.todayDate(), this.birthDayDate());
  };

  Player.prototype.birthDay = function() {
    return this.opts.birthYear + ' ' + this.opts.birthMonth + ' ' + this.opts.birthDay;
  };

  Player.prototype.date = function() {
    var d, day, month, year;
    d = this.todayDate();
    day = d.getDate();
    month = d.getMonth();
    year = d.getFullYear();
    return year + "-" + month + "-" + day;
  };

  Player.prototype.time = function() {
    var d, hour;
    d = this.todayDate();
    hour = d.getHours();
    return hour + '00';
  };

  Player.prototype.spend = function(n) {
    var cash;
    cash = this.opts.cash - n;
    if (cash > 0) {
      this.opts.cash = cash;
      this.updateStatic('cash');
      return true;
    } else {
      return false;
    }
  };

  Player.prototype.useFood = function() {
    var hunger;
    hunger = this.opts.hunger;
    if (hunger === 18) {
      this.opts.mood = 'starving';
    }
    if (hunger === 20) {
      return false;
    }
    this.opts.hunger++;
    this.updateStatic('hunger');
    return true;
  };

  Player.prototype.useStamina = function() {
    var stamina;
    stamina = this.opts.stamina;
    if (stamina === 2) {
      this.opts.mood = 'tired';
    }
    if (stamina === 0) {
      return false;
    }
    this.opts.stamina--;
    this.updateStatic('stamina');
    return true;
  };

  Player.prototype.useHour = function() {
    var hours;
    hours = this.opts.playerHour;
    if (hours === 23) {
      this.opts.playerHour = 0;
      this.opts.playerDay++;
    } else {
      this.opts.playerHour++;
    }
    if (hours === 10) {
      this.set('cash', this.opts.cash - 50);
      this.updateStatic('cash');
    }
    this.updateDynamic('date', this.date());
    this.updateDynamic('time', this.time());
    return true;
  };

  Player.prototype.loiter = function() {
    this.useFood();
    this.useStamina();
    return this.useHour();
  };

  Player.prototype.eat = function() {
    var hunger;
    this.useHour();
    hunger = this.opts.hunger - 10;
    if (hunger < 0) {
      this.opts.hunger = 0;
    } else {
      this.opts.hunger = hunger;
    }
    this.updateStatic('hunger');
    return true;
  };

  Player.prototype.sleep = function() {
    this.useHour();
    this.useHour();
    this.useHour();
    this.useHour();
    this.useHour();
    this.useHour();
    this.useHour();
    this.useHour();
    this.useFood();
    this.useFood();
    this.opts.stamina = 20;
    this.update('mood', 'fair');
    this.updateStatic('mood');
    this.updateStatic('stamina');
    return true;
  };

  Player.prototype.purchaseBuffet = function() {
    if (this.spend(25)) {
      this.eat();
      this.useStamina();
      return true;
    } else {
      return false;
    }
  };

  Player.prototype.stayAtBuffet = function() {
    this.eat();
    this.useStamina();
    return true;
  };

  window.Card = function(options) {
    this.opts = options || {};
    this.opts.suit = options.suit || 0;
    this.opts.value = options.value || 0;
    return this;
  };

  Card.prototype.value = function() {
    return this.opts.value;
  };

  Card.prototype.suit = function() {
    return this.opts.suit;
  };

  Card.prototype.suitName = function() {
    var suitNames;
    suitNames = ['hearts', 'diamonds', 'clubs', 'spades'];
    return suitNames[this.opts.suit];
  };

  Card.prototype.unicodeSuit = function() {
    var suitUnicodeOutline;
    suitUnicodeOutline = ['\u2661', '\u2662', '\u2667', '\u2664'];
    return suitUnicodeOutline[this.opts.suit];
  };

  Card.prototype.color = function() {
    if (this.suit() === 0 || this.suit() === 1) {
      return 'red';
    } else {
      return 'black';
    }
  };

  if (window.location.href !== "http://localhost/vegas.hyprtxt.com/dev/index.html") {
    if (storage('Vegas').get() === void 0) {
      window.location.replace('index.html');
    } else {
      window.the_player = new Player(storage('Vegas').get());
    }
  }

}).call(this);
