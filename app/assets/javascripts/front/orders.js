//note: в примере используется библиотека jquery

$(document).ready(function(){
    $('#delivery_region_2').on('click', function(){
        $('#city_input').show(350);
    });

    $('#delivery_region_1').on('click', function(){
        $('#city_input').hide(350);
    });

});

this.pay = function () {
    var widget = new cp.CloudPayments();
    var email = $("#email").val();
    widget.charge({ // options
            publicId: 'pk_35b1b441a2f142c5317bdf2810e16',  //id из личного кабинета
            description: 'С вас спишется сумма заказа', //назначение
            amount: 10, //сумма
            currency: 'RUB', //валюта
            invoiceId: '1234567', //номер заказа  (необязательно)
            accountId: email, //идентификатор плательщика (необязательно)
            data: {
                myProp: 'myProp value' //произвольный набор параметров
            }
        },
        function (options) { // success
            console.log("Payment successful!");
            $('#order_payed_online').val(true);
            $("#courier_cash").prop('disabled', true);
            $('#payment_status').html("<div class='alert alert-success'><p>Оплата прошла успешно!</p></div>");
            //действие при успешной оплате
        },
        function (reason, options) { // fail
            $('#payment_status').html("<div class='alert alert-danger'><p>К сожалению, оплата не прошла.</p></div>");
            //действие при неуспешной оплате
        });
};

$('#card_online').click(pay);

$('#courier_cash').click(function(){
    $('#order_payed_online').val(false);
    $('#payment_status').hide();
});
