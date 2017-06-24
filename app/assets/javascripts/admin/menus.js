
$('menus').ready(function(){ 

  $('.select2-single').select2({
    placeholder: 'Выберите значение...'
  });

  $('.select-recipes').select2({
    placeholder: 'Выбрать рецепты для данного набора',
    allowClear: true
  });

  $('.select-personamount').select2({
    placeholder: 'Выбрать кол-во персон для данного набора',
    allowClear: true
  });

  $('.select-deliveries').select2({
    placeholder: 'Выбрать доступные дни доставки',
    allowClear: true
  });

  $('.select-days').select2({
    placeholder: 'Выбрать кол-во ужинов для данного набора',
    allowClear: true
  });

  $('.select2-primary').select2();
  $('.select2-success').select2();
  $('.select2-info').select2();
  $('.select2-warning').select2();
  $('#multiselect1').multiselect();
  $('#multiselect2').multiselect({
    includeSelectAllOption: true
  });
  $('#multiselect3').multiselect();
  $('#multiselect4').multiselect({
    enableFiltering: true
  });
  $('#multiselect5').multiselect({
    buttonClass: 'multiselect dropdown-toggle btn btn-default btn-primary'
  });
  $('#multiselect6').multiselect({
    buttonClass: 'multiselect dropdown-toggle btn btn-default btn-info'
  });
  $('#multiselect7').multiselect({
    buttonClass: 'multiselect dropdown-toggle btn btn-default btn-success'
  });
  $('#multiselect8').multiselect({
    buttonClass: 'multiselect dropdown-toggle btn btn-default btn-warning'
  });
  
  $('#daterangepicker1').daterangepicker();
});
