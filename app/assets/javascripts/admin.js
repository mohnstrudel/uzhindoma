//
//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/
//
//
//


//= require_tree ../../../vendor/assets/javascripts/admin/plugins/moment/.

//= require jquery
//= require jquery_ujs

//= require_tree ../../../vendor/assets/javascripts/admin/plugins/.
//= require_tree ../../../vendor/assets/javascripts/admin/daterange/.
//= require_tree ../../../vendor/assets/javascripts/admin/utility/.

//= require_tree ../../../vendor/assets/javascripts/admin/demo/.

//= require admin/main

//= require_self
//= require_tree ../../../app/assets/javascripts/admin/.

//= require turbolinks




jQuery(document).ready(function() {

    "use strict";

    // Init Theme Core    
    Core.init();

    // Init Demo JS  
    Demo.init();

    // select list dropdowns - placeholder like creation
    var selectList = $('.admin-form select');
    selectList.each(function(i, e) {
      $(e).on('change', function() {
        if ($(e).val() == "0") $(e).addClass("empty");
        else $(e).removeClass("empty")
      });
    });
    selectList.each(function(i, e) {
      $(e).change();
    });

    // Init TagsInput plugin
    $("input#tagsinput").tagsinput({
      tagClass: function(item) {
        return 'label bg-primary light';
      }
    });

  });