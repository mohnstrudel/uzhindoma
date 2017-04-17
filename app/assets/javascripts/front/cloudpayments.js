this.pay = function () {
    var widget = new cp.CloudPayments();
    var email = $("#email").val();
    var order_id = $("#order_id").val();
    var amount = parseFloat($("#order_price").val());
    widget.charge({ // options
            publicId: 'pk_35b1b441a2f142c5317bdf2810e16',  //id из личного кабинета
            description: 'Оплата заказа', //назначение
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
            $('#payment_status').html("<div class='alert alert-success'><p>Оплата прошла успешно!</p></div>");
            //действие при успешной оплате
        },
        function (reason, options) { // fail
            $('#payment_status').html("<div class='alert alert-danger'><p>К сожалению, оплата не прошла.</p></div>");
            //действие при неуспешной оплате
        });
};

$('#transfer').click(pay);

$('#cash').click(function(){
    $('#order_payed_online').val(false);
    $('#payment_status').hide();
});