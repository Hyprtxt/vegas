(function() {
  var awesome, playPoker, reportHand;

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

  window.calculateAge = function(date, birthday) {
    var ageDate, ageDifMs;
    ageDifMs = date.getTime() - birthday.getTime();
    ageDate = new Date(ageDifMs);
    return Math.abs(ageDate.getUTCFullYear() - 1970);
  };

  window.ClubCard = function(options) {
    this.opts = options || {};
    return this;
  };

  if (window.location.href !== "http://localhost/vegas.hyprtxt.com/dev/index.html") {
    if (storage('Vegas').get() === void 0) {
      window.location.replace('index.html');
    } else {
      window.the_player = new Player(storage('Vegas').get());
    }
  }

  reportHand = function(a_hand) {
    if (a_hand.type === 'strategy') {
      a_hand = a_hand.hand;
    }
    return a_hand.cards.map(function(card, i) {
      return card.valueLetter() + card.unicodeSuit();
    });
  };

  playPoker = function(stream) {
    var Strategey, TheDeck, TheHand, bet, credits, score, theGame;
    credits = 0;
    Strategey = new Simple();
    TheDeck = new Deck();
    TheDeck.shuffle();
    TheHand = new Hand({
      deck: TheDeck,
      size: 5
    });
    $('pre').html('');
    $('pre').append(reportHand(TheHand) + ' ');
    $('pre').append(JacksOrBetter.score(TheHand, bet).status + '\n');
    theGame = Strategey.play(TheHand);
    $('pre').append(theGame.rule + '\n');
    $('pre').append(reportHand(TheHand) + ' ');
    bet = 5;
    score = JacksOrBetter.score(theGame, bet);
    credits = credits - bet;
    credits = credits + score.win;
    the_player.set('cash', the_player.get('cash') + credits);
    the_player.increment('hands');
    return $('pre').append(score.status);
  };

  awesome = function() {
    return playPoker();
  };

  awesome();

}).call(this);
