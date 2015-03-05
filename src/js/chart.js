// var $ = require('jquery');
// var Chartist = require('chartist')

var chart = {
  pie: function ( selector, data ) {
    self = this;
    if ( data.rows.length === 1 ) {
      Chartist.Pie( selector, {
        series: data.rows[0].map(Number),
        labels: data.query.metrics
      });
    }
    else {
      // Incorrect
      Chartist.Bar( selector, self.multiRowChartDataSetup ( data ) );
    }
  },
  bar: function ( selector, data ) {
    self = this;
    if ( data.rows.length === 1 ) {
      Chartist.Bar( selector, {
        series: [ data.rows[0].map(Number) ],
        labels: data.query.metrics
      });
    }
    else {
      Chartist.Bar( selector, self.multiRowChartDataSetup ( data ) );
    }
  },
  line: function ( selector, data ) {
    self = this;
    if ( data.rows.length === 1 ) {
      // Incorrect
      Chartist.Bar( selector, {
        series: [ data.rows[0].map(Number) ],
        labels: data.query.metrics
      });
    }
    else {
      Chartist.Line( selector, self.multiRowChartDataSetup ( data ) );
    }
  },
  multiRowChartDataSetup: function ( data ) {
    var chartData = {
      labels: [],
      series: []
    };
    $.each( data.rows, function ( index, row ) {
      $.each( row, function ( idx, cell ) {
        // console.log( index, row, idx, cell );
        if ( index === 0 ) {
          if ( idx !== 0 ) {
            chartData.series[ idx-1 ] = { data: [] };
          }
        }
        if ( idx !== 0 ) {
          chartData.series[ idx-1 ].data.push( cell );
        }
        else {
          chartData.labels.push( cell );
        }
      });
    });
    return chartData;
  }
};