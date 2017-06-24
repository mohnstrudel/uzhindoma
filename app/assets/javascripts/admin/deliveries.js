$('form').on('click', ".remove_record", function(event){
  $(this).prev('input[type=hidden]').val('1');
  $(this).closest('.interval_row').hide();
  return event.preventDefault();
});

$('form').on('click', '.add_interval_fields', function(event) {
  var regexp, time;
  time = new Date().getTime();
  regexp = new RegExp($(this).data('id'), 'g');
  $(this).before($(this).data('fields').replace(regexp, time));
  return event.preventDefault();
});