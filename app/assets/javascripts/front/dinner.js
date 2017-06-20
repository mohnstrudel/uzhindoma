$(document).ready(function(){

  // Default behaviour
  var $menu_node = $(".g-menu-block");
    var current_type = $menu_node.data("show"), $current_list = $menu_node.find(".m-menu-items__list[data-type='" + current_type + "']");
    var breakfast_text = $current_list.data('breakfast');
    $('#add-breakfast').html(breakfast_text);

  // Click behaviour
  $(".js-main-menu").on("click", function(e){
    e.preventDefault();
    var $menu_node = $(".g-menu-block");
    var current_type = $menu_node.data("show"), $current_list = $menu_node.find(".m-menu-items__list[data-type='" + current_type + "']");
    var breakfast_text = $current_list.data('breakfast');
    $('#add-breakfast').html(breakfast_text);
  });
});
