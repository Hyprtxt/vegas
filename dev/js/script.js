(function() {
  var addBlock, addBlockButtons, blocks, getBlocks, getQuery, renderBlock, report, saveReport;

  blocks = [];

  report = {};

  report.blocks_list = [];

  report.blocks = [];

  getBlocks = function(callback) {
    return $.ajax({
      url: 'http://api.yothrow.com/block',
      data: {
        secret: 'secret'
      }
    }).done(callback);
  };

  addBlockButtons = function(data) {
    blocks = data;
    return $(data).each(function(i, v) {
      return $('#blocks').append('<li><button class="add-block" id="' + v.id + '">' + v.name + '</button></li>');
    });
  };

  getQuery = function(id, callback) {
    return $.ajax({
      url: 'http://yothrow.com/api/result/' + id,
      data: {
        'testing': 'supersecret'
      }
    }).done(callback);
  };

  renderBlock = function(block) {
    block.number = report.blocks_list.length;
    return tmpl.renderTemplate(block, 'block', [], function(template) {
      var selector;
      $('#output').append(template);
      if (block.chart) {
        selector = '#chart' + block.number;
        return chart[block.chart_type](selector, block.data);
      }
    });
  };

  addBlock = function(e) {
    var block;
    block = _.findWhere(blocks, {
      'id': parseInt($(e.target).attr('id'))
    });
    report.blocks_list.push(block.id);
    return getQuery(block.query, function(data) {
      block.data = data;
      report.blocks.push(block);
      return renderBlock(block);
    });
  };

  saveReport = function(e) {
    console.log(e, report);
    report.name = $('#name').val();
    $.ajax({
      type: 'POST',
      url: 'http://api.yothrow.com/report/create/',
      data: report,
      dataType: 'json',
      success: function(res) {
        console.log(res);
        return alert(res);
      }
    });
    return false;
  };

  getBlocks(addBlockButtons);

  $('body').on('click', '.add-block', addBlock);

  $('body').on('click', '.save-report', saveReport);

}).call(this);
