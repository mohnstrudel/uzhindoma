this.pay = function () {
var widget = new cp.CloudPayments();
var email = $("#email").val();
var order_id = $("#order_id").val();
var amount = parseFloat($("#order_price").val());
widget.charge({ // options
        publicId: 'pk_6bbb5742d0140cdd4d7d1432de848',  //id из личного кабинета ПРОДАКШН
        // publicId: 'pk_8dc065172902e15e2e75fb43d2015', // ДЕВЕЛОПМЕНТ
        description: 'Оплата заказа Ужин Дома', //назначение
        amount: amount, //сумма
        currency: 'RUB', //валюта
        invoiceId: order_id, //номер заказа  (необязательно)
        accountId: email, //идентификатор плательщика (необязательно)
        data: {
            myProp: 'myProp value' //произвольный набор параметров
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


