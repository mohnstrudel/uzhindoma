this.pay = function () {
var widget = new cp.CloudPayments();
var email = $("#email").val();
var order_id = $("#order_id").val();
var amount = parseFloat($("#order_price").val());
var order = $('form').data('order');
var breakfast = $('form').data('breakfast');
var dessert = $('form').data('dessert');
var menu = $('form').data('current-menu');

var items_array = [];

items_array.push(
    {
      label: menu.name, //наименование товара
      price: menu.price, //цена
      quantity: 1.00, //количество 
      amount: menu.price, //сумма
      vat: null, //ставка НДС
      ean13: null //штрих-код
    }
  );

if (typeof breakfast !== 'undefined' && breakfast !== null) {
  items_array.push(
    {
      label: breakfast.name, //наименование товара
      price: breakfast.price, //цена
      quantity: 1.00, //количество 
      amount: breakfast.price, //сумма
      vat: null, //ставка НДС
      ean13: null //штрих-код
    }
  );
}

if (typeof dessert !== 'undefined' && dessert !== null) {
  items_array.push(
    {
      label: dessert.name, //наименование товара
      price: dessert.price, //цена
      quantity: 1.00, //количество 
      amount: dessert.price, //сумма
      vat: null, //ставка НДС
      ean13: null //штрих-код
    }
  );
}




widget.charge({ // options
        publicId: 'pk_6bbb5742d0140cdd4d7d1432de848',  //id из личного кабинета ПРОДАКШН
        // publicId: 'pk_8dc065172902e15e2e75fb43d2015', // ДЕВЕЛОПМЕНТ
        description: 'Оплата заказа Ужин Дома', //назначение
        amount: amount, //сумма
        currency: 'RUB', //валюта
        invoiceId: order_id, //номер заказа  (необязательно)
        accountId: email, //идентификатор плательщика (необязательно)
        data: {
            cloudPayments: {
                customerReceipt: {
                    Items: items_array,
                    taxationSystem: 2, //система налогообложения
                    email: order.email, //e-mail покупателя или
                    phone: order.phone //телефон покупателя в любом формате
                }
            }
        }
    },
    function (options) { // success
        console.log("Payment successful!");
        $('#order_payed_online').val(true);
        $("#courier_cash").prop('disabled', true);
        // $('#notifications')
        // %p.g-info-text
        
        $.ajax({
            type: "PUT",
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            dataType: "json",
            url: '/orders/'+order_id,
            contentType: 'application/json',
            data: JSON.stringify({order: {cloudpayment: true}}),
            success: function(response){
                //действие при успешной оплате
                
            }
        }).done(function( msg )
        {
            
        });
        $("#successful_payment").fadeIn(300);
        
    },
    function (reason, options) { // fail
        $("#unsuccessful_payment").fadeIn(300);
        //действие при неуспешной оплате
    });
};

$('#transfer').click(pay);

$('#cash').click(function(){
    $('#order_payed_online').val(false);
    $('#payment_status').hide();
    });    


