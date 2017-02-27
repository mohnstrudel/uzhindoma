$('#datetimepicker_begin').datetimepicker({
  dateFormat: "dd-mm-yy",
  timeFormat: "HH:mm",
  prevText: '<i class="fa fa-chevron-left"></i>',
  nextText: '<i class="fa fa-chevron-right"></i>',
  beforeShow: function(input, inst) {

    var newclass = 'admin-form';
    var themeClass = $(this).parents('.admin-form').attr('class');
    var smartpikr = inst.dpDiv.parent();
    if (!smartpikr.hasClass(themeClass)) {
      inst.dpDiv.wrap('<div class="' + themeClass + '"></div>');
    }
  }
});

$('#datetimepicker_end').datetimepicker({
  dateFormat: "dd-mm-yy",
  timeFormat: "HH:mm",
  prevText: '<i class="fa fa-chevron-left"></i>',
  nextText: '<i class="fa fa-chevron-right"></i>',
  beforeShow: function(input, inst) {
    var newclass = 'admin-form';
    var themeClass = $(this).parents('.admin-form').attr('class');
    var smartpikr = inst.dpDiv.parent();
    if (!smartpikr.hasClass(themeClass)) {
      inst.dpDiv.wrap('<div class="' + themeClass + '"></div>');
    }
  }
});