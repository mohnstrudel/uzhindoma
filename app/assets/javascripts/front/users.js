$('session.new').ready(function(){
	console.log("Users.js loaded!");

	if ($('.alert-danger').length) {
		// $("#signin_password").removeClass('hidden');
		// $("#signin_button").removeClass('hidden');
		$('#reset_btn').prop('disabled', true);
		$('#reset_btn').val('Повторить можно через 60 секунд').fadeIn( 400 );
		setTimeout( function() 
  		{

  			$('#reset_btn').prop('disabled', false);
  			$('#reset_btn').val('Выслать пароль по смс').fadeIn( 400 );
  		}, 60000);
		
	// console.log("Flash alert exists!");
	} 
		else if ($('.alert-success').length) {
			console.log("Alert success detected. Hiding phone and showing password");
			$("#signin_phone").addClass('hidden');
			$('#reset_btn').val('Повторить можно через 60 секунд').fadeIn( 400 );
			setTimeout( function() 
	  		{

	  			$('#reset_btn').prop('disabled', false);
	  			$('#reset_btn').val('Выслать пароль по смс').fadeIn( 400 );
	  		}, 60000);
			
			$("#signin_password").removeClass('hidden');
			$("#signin_button").removeClass('hidden');
	} 
		else {
		console.log("Page is clear!");
	}



});

