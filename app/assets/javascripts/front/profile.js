  // Удаляем новые адреса на странице профиля пользователя

  $('form').on('click', '.remove_fields', function(event){
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('fieldset').hide();
    event.preventDefault();
  });

  // Добавляем новые адреса на странице профиля пользователия

  $('form').on('click', '.add_address_fields', function(event) {
    // console.log("Add new fields clicked!");
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    event.preventDefault();
    });