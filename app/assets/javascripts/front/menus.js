// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/



//to top function
jQuery(document).on('scroll', function() {
  if (jQuery('body').scrollTop() > 100) {
    jQuery('#on-top').fadeIn('fast');
  }else{
    jQuery('#on-top').fadeOut('fast');
  }
});
jQuery('#on-top').on('click', function(e){
  e.preventDefault();
  $("html, body").animate({ scrollTop: 0 }, "slow");
    return false;
})



$(document).ready(function() {


  var activeTab = 0;

  // Получаем текущий таб
  $('a[data-toggle="tab"]').on('shown.bs.tab', function(e){
        var activeTab = $(e.target).attr('href');
        var tabId = activeTab.split('-')[1];
        activeTab = parseFloat(tabId);
        console.log("Menus. js active tab is: " + activeTab);

    set_tab(activeTab);
  });

  var set_tab = function(tab) {
    activeTab = tab;
  }
  

  $('.uzhin_rb_menus input:radio').on('change', function(){
    var radio_button_value = $(this).val();
    // console.log($(this).val() + " has changed");

    // При выборе кол-ва ужинов мы получаем инпут в виде массива = [5,1200,600] 
    // 5 - кол-во ужинов, которое нам нужно получить (1200 и 600 - это добавка к стоимости)
    dinner_amount = extract_amount_from_array(radio_button_value);

    // Затемняем невыбранное кол-во ужинов
    darken_it(dinner_amount);

  });

  // Теперь аналогично как для меню, только для десертов
  $('.uzhin_rb_dessert input:radio').on('change', function(){
    var radio_button_value = parseFloat($(this).val());
    console.log("Dessert radio button check value: " + radio_button_value);

    var dessert_item = 5 + 6 * activeTab;
    if (radio_button_value == 0){
      $('.item').eq(dessert_item).addClass('disabled');
    } else {
      $('.item').eq(dessert_item).removeClass('disabled');
    }
    
  });

  // Затемнить десерты по умолчанию
  $('.item').eq(5).addClass('disabled');
  $('.item').eq(11).addClass('disabled');
  $('.item').eq(17).addClass('disabled');


  var extract_amount_from_array = function(value){
    // console.log("Input is: " + value[1]);
    // var splitted_array = value.split(",");
    // var result = splitted_array.replace('[','').replace(' ', '');
    result = parseFloat(value[1]);

    return result;
  }
  
  // Функция затемнения

  var darken_it = function (amount) {

    console.log("Darkening " + amount + " dinners on tab " + activeTab);
    var fourth_image = 3 + 6 * activeTab;
    var fifth_image = 4 + 6 * activeTab;
    if (amount == 5){
      jQuery('.item').eq(fourth_image).removeClass('disabled');
      jQuery('.item').eq(fifth_image).removeClass('disabled');
    } else if (amount == 4) {
      jQuery('.item').eq(fourth_image).removeClass('disabled');
      jQuery('.item').eq(fifth_image).addClass('disabled');
    } else if (amount == 3) {
      console.log(fourth_image);
      console.log(fifth_image);
      jQuery('.item').eq(fourth_image).addClass('disabled');
      jQuery('.item').eq(fifth_image).addClass('disabled');
    }
  }
});

