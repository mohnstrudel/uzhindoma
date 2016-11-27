//note: в примере используется библиотека jquery

this.pay = function () {
    var widget = new cp.CloudPayments();
    var email = $("#email").val();
    widget.charge({ // options
            publicId: 'pk_c5ded818fb3fab18c2323ceda9600',  //id из личного кабинета
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
            $('#payment_status').html("<p>Оплата прошла успешно!</p>");
            //действие при успешной оплате
        },
        function (reason, options) { // fail
            $('#payment_status').html("<p>К сожалению, оплата не прошла.</p>");
            //действие при неуспешной оплате
        });
};

$('#card_online').click(pay);

$('#courier_cash').click(function(){
    $('#order_payed_online').val(false);
    $('#payment_status').hide();
});
