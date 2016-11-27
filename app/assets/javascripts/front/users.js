$(document).ready(function(){
	if ($('.alert').length) {
		$('#reset_btn').prop('disabled', true);
		$('#reset_btn').val('Повторить можно через 60 секунд').fadeIn( 400 );
		setTimeout( function() 
  		{

  			$('#reset_btn').prop('disabled', false);
  		}, 60000);
		
	// console.log("Flash alert exists!");
	} else {
		console.log("Page is clear!");
	}



});

