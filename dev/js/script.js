(function() {
  console.log('script.coffee');

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

}).call(this);
