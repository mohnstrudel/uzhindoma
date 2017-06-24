$("#new_subscriber").on("ajax:success", function(e, data, status, xhr) {
  $("#success-review").fadeIn(200);

}).on("ajax:error", function(e, data, status, xhr) {
  // var $form = $("#new_subscriber"),
  //   $email_input = $form.find("input[name='feedback[email]']"),
  //   email = $email_input.val();
  //   if(email == ""){
  //       $email_input.addClass("g-input_error");
  //       // error = true;
  //   }
  console.log("Hello, error!");
  console.log(data);
  console.log(e);
  console.log(status);
});



