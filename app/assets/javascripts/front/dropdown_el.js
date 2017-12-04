$('.dropdown-el').click(function(e) {
    // e.preventDefault();
    e.stopPropagation();
    $(this).toggleClass('expanded');
    $('#'+$(e.target).attr('for')).prop('checked',true);
  });
$('a#sort-relevance_E').click(function(e) {
  e.preventDefault();
});
$(document).click(function() {
  $('.dropdown-el').removeClass('expanded');
});
