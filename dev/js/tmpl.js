var tmpl = {
  // JS Views Stuff
  renderTemplate: function ( data, template, deps, callback ) {
    // Renders Templates with includes, define an array of template
    // names to load them up before adding them to the page
    self = this;
    if ( deps === undefined ) deps = [];
    $.when(
      $.each( deps, function ( i, v ) {
        self.getTemplate( v );
      }),
      self.getTemplate( template )
    )
    .done( function () {
      if ( callback !== undefined ) {
        console.log( 'callback' );
        callback( $.templates[template].render( data ) );
      }
      else {
        console.log( 'no callback' );
        return $.templates[template].render( data );
      }
    });
  },
  getTemplate: function ( name ) {
    // Lazy Get Template
    // If the named remote template is not yet loaded and compiled
    // as a named template, fetch it. In either case, return a promise
    // (already resolved, if the template has already been loaded)
    var deferred = $.Deferred();
    if ($.templates[name]) {
      deferred.resolve();
    } else {
      $.when(
        $.get( 'tmpl/' + name + '.tmpl.html' )
      )
      .done(function(tmplData) {
        var daTemplate = {};
        daTemplate[name] = tmplData;
        $.templates(daTemplate);
        if ($.templates[name]) {
          deferred.resolve();
        } else {
          alert("Template: \"" + name + ".tmpl.html\" failed to load");
          deferred.reject();
        }
      });
    }
    return deferred.promise();
  }
};