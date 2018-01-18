$(document).ready(function(){

  // Default behaviour
  var $menu_node = $(".g-menu-block");
    var current_type = $menu_node.data("show"), $current_list = $menu_node.find(".m-menu-items__list[data-type='" + current_type + "']");
    var breakfast_text = $current_list.data('breakfast');
    $('#add-breakfast').html(breakfast_text);

    if($current_list.data('purchasable') == false){
      $(".hide_purchase").hide();  
    } else {
      $(".hide_purchase").show();  
    }

    if($current_list.data('display-persons') == false){
      $(".hide_persons").hide();  
    } else {
      $(".hide_persons").show();  
    }

    if($current_list.data('display-days') == false){
      $(".hide_days").hide();  
    } else {
      $(".hide_days").show();  
    }

    if($current_list.data('display-description') == false){
      $(".hide_description").hide();  
    } else {
      $(".hide_description").show();  
    }

  // Click behaviour
  $(".js-main-menu").on("click", function(e){
    e.preventDefault();
    var $menu_node = $(".g-menu-block");
    var current_type = $menu_node.data("show"), $current_list = $menu_node.find(".m-menu-items__list[data-type='" + current_type + "']");
    var breakfast_text = $current_list.data('breakfast');
    $('#add-breakfast').html(breakfast_text);

    // Скрываем опции для заказа, если категория недоступна для заказа

    // console.log($current_list.data('purchasable'));
    if($current_list.data('purchasable') == false){
    // console.log('purchasable is false');
    $(".hide_purchase").hide();  
    }
    else {
      $(".hide_purchase").show();      
    }

    if($current_list.data('display-persons') == false){
      $(".hide_persons").hide();  
    } else {
      $(".hide_persons").show();  
    }

    if($current_list.data('display-days') == false){
      $(".hide_days").hide();  
    } else {
      $(".hide_days").show();  
    }

    if($current_list.data('display-description') == false){
      $(".hide_description").hide();  
    } else {
      $(".hide_description").show();  
    }

  });


  
});
