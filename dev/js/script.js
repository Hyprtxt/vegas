(function() {
  var calculateAge;

  console.log('script.coffee');

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

  window.ClubCard = function(options) {};

  window.Player = function(options) {
    this.opts = options || {};
    this.opts.name = options.name || '';
    this.opts.mood = options.mood || '';
    this.opts.stamina = options.stamina || 20;
    this.opts.hunger = options.hunger || 10;
    this.opts.location = options.location || '';
    this.opts.cash = options.cash || '0.00';
    this.opts.inventory = options.inventory || [];
    this.opts.birthYear = options.birthYear || 1987;
    this.opts.birthMonth = options.birthMonth || 7;
    this.opts.birthDay = options.birthDay || 21;
    this.opts.playerRetireDate = options.playerRetireDate || new Date().now();
    this.opts.playerDay = options.playerDay || 5;
    this.opts.playerHour = options.playerHour || 6;
    return this;
  };

  Player.prototype.birthDayDate = function() {
    return new Date(this.opts.birthYear, this.opts.birthMonth, this.opts.birthDay);
  };

  Player.prototype.todayDate = function() {
    var date, days, hours;
    days = this.opts.playerDay * 86400000;
    hours = this.opts.playerHour * 3600000;
    console.log(this.opts.playerRetireDate + days + hours);
    date = new Date(this.opts.playerRetireDate + days + hours);
    return date;
  };

  Player.prototype.age = function() {
    return calculateAge(this.todayDate(), this.birthDayDate());
  };

  Player.prototype.birthDay = function() {
    return this.opts.birthYear + ' ' + this.opts.birthMonth + ' ' + this.opts.birthDay;
  };

  Player.prototype.today = function() {
    var d, day, hour, month, year;
    d = this.todayDate();
    hour = d.getHours();
    day = d.getDate();
    month = d.getMonth();
    year = d.getFullYear();
    return year + "-" + month + "-" + day + ' ' + hour;
  };

  Player.prototype.useCash = function(n) {
    var cash;
    cash = this.opts.cash - n;
    if (cash > 0) {
      this.opts.cash = cash;
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
    this.useFood();
    this.useStamina();
    return true;
  };

  Player.prototype.purchaseBuffet = function() {
    if (this.useCash(25)) {
      this.eat();
      this.useStamina();
      return true;
    } else {
      return false;
    }
  };

  Player.prototype.purchaseBuffet = function() {};

  Player.prototype.eat = function() {
    var hunger;
    hunger = this.opts.hunger + 10;
    if (hunger > 21) {
      this.opts.hunger = 20;
    } else {
      this.opts.hunger = hunger;
    }
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

}).call(this);
