// $("#new_feedback").on("submit", function(e){
//   e.preventDefault();
  
      
//   var $form = $(this),
//       $submit_button = $form.find("input[type='submit']"),
//       $name_input = $form.find("input[name='feedback[name]']"),
//       name = $name_input.val(),
//       $email_input = $form.find("input[name='feedback[email]']"),
//       email = $email_input.val(),
//       $message_input = $form.find("textarea[name='feedback[body]']"),
//       message = $message_input.val(),
//       error = false;
//       if(name == ""){
//           $name_input.addClass("g-input_error");
//           error = true;
//       }
//       if(!validateEmail(email)){
//           $email_input.addClass("g-input_error");
//           error = true;
//       }
//       if(message == ""){
//           $message_input.addClass("g-input_error");
//           error = true;
//       }

//   $submit_button.prop('disabled', true).addClass("g-btn_disabled");

//   console.log($("[name='rating']:checked").val());
//   if(!error){
//            $.ajax({
//              data: $(this).serialize(),
//              url: "/feedbacks",
//              method: "POST",
//              success: function(){
//                   $name_input.val("");
//                   $email_input.val("");
//                   $message_input.val("");
//                   $("[name='rating']:checked").prop("checked", false);
//                   $("#success-review").fadeIn(200);

//              }
//          });                
//   }
//   return false;
// });