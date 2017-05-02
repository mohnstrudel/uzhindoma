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

  $('#send_sms_link').on('click', function(event){
    event.preventDefault();
    var current_this = $(this);
    current_this.html("Повторить можно через 45 секунд").addClass('disabled');
    setTimeout(function(){
      current_this.html("Выслать пароль по СМС").removeClass('disabled');
    }, 45000);

    console.log("Link clicked: " + current_this.val());

    var phone = $('#phone_input').val();
    // console.log("Data: " + $(this).serialize());
    $.ajax({
      data: { phone: phone },
      url: "/send_sms",
      method: "GET",
      success: function(){
      }
    });
  });