// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require_tree ../../../vendor/assets/javascripts/front/.


//= require_self
//= require_tree ../../../app/assets/javascripts/front/.


//= require turbolinks


$(document).ready(function(){
	$("ul").on("click", "li", function(){
		console.log($(this)['context'].innerHTML);
		$.ajax({
			type: "GET",
			url: "/dinner",
			success: function (result){
				console.log($(result).find("#uzhin_price"));
			}

		});
	});	

	if($(".swiper-slide").length < 2){
		console.log("only one!");
    	swiper.stopAutoplay();
  		$(".swiper-button").css("display", "none");
	}
});


