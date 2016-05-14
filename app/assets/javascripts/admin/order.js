// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function(){


    

	$("#order_users").on('change', function(){
		
		// $.ajax("/admin/users/", {id: $(this).val()}).success(function(data){
		// 	console.log(data);
		// });

		$.ajax({
      		url: "/admin/users/"+$(this).val()+".json",
      		dataType: "json",
      		// data:  $.param({id: $(this).val()}),
      		success: function(data){
      			console.log("Successful call");
         		
         		var name = data["name"];
         		var phone = data["phone"];
         		var email = data["email"];
         		var address = data["address"];
         		
         		$("#name").val(name);
         		$("#phone").val(phone);
         		$("#email").val(email);
         		$("#address").val(address);
      		},
      		error: function(data){
      			console.log("Failed call");
      		}
   		});
	});
});