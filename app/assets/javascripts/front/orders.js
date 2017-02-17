//note: в примере используется библиотека jquery

$(document).ready(function(){
    $('#delivery_region_2').on('click', function(){
        $('#city_input').show(350);
    });

    $('#delivery_region_1').on('click', function(){
        $('#city_input').hide(350);
    });

    // $('#promocode').keyup(function(e){
    //     var element = $('#promocode').val();
    //     // var event = e;
    //     $.ajax({
    //         type: "GET",
    //         contentType: "application/json; charset=utf-8",
    //         url: "/promocodes/"
    //     });
    //     // console.log("Element - " + element + " triggerd with event: " + String.fromCharCode(event.keyCode));
    // });

    $('.submit-order').on('click', function(e){
        if ($("input[name='order[delivery_timeframe]']:checked").length > 0) {
            // Если интервал доставки выбран, то все чики пуки, ничего не делаем
            // Но если мы до этого нажали на отправить и все-таки выбрали интервал и нажали снова,
            // то удаляем ошибку и текст
            $('#delivery-container').children("p").remove();
        } else {
            // Удаляем возможные предыдущие статусы
            $('#delivery-container').children("p").remove();
            // Если не выбран, то не даем заказать
            e.preventDefault();
            $('#delivery-container').append("<p><b>Необходимо выбрать интервал доставки!<b></p>");
        }
        // Проверяем также на обязательное заполнение полей НОВОГО адреса, но только
        // если данная опция выбрана, т.е. если эти поля ВИДНЫ


        

        if (!$('.optional_address_block').hasClass("hidden"))
        {

            if ($("input[name='order[delivery_region]']:checked").length > 0) {
                // Тут проверяем город
                // console.log("Регион выбран!");
                $('#region_input').children("p").remove();
                // console.log("Значение региона - " + $("input[name='order[delivery_region]']:checked").val());
                if ($("input[name='order[delivery_region]']:checked").val() == "Московская область"){
                    // console.log("Регион доставки выбран: Московская область.")
                    if ($('#city_input input').val().length === 0)
                    {   
                        // console.log("Улица пустая! - " + $('#street_input input').val());
                        $('#city_input').children("p").remove();
                        $('#city_input').append("<p><b>Необходимо заполнить данное поле!<b></p>");
                        e.preventDefault();  
                        // console.log("Не заполнен ГОРОД, не даю нажать дальше!");  
                    }
                } else {
                    // console.log("Регион доставки выбран: Москва");
                }
            } else {
                // console.log("Город не выбран!");
                // Удаляем возможные предыдущие статусы
                $('#region_input').children("p").remove();
                // Если не выбран, то не даем заказать
                $('#region_input').append("<p><b>Необходимо выбрать регион доставки!<b></p>");
                e.preventDefault();
                // console.log("Не заполнен РЕГИОН, не даю нажать дальше!");  
            }

            console.log('Optional new address is visible');
            // Тут устраиваем проверку на заполненность полей
            if ($('#street_input input').val().length === 0)
            {   
                // console.log("Улица пустая! - " + $('#street_input input').val());
                $('#street_input').children("p").remove();
                $('#street_input').append("<p><b>Необходимо заполнить данное поле!<b></p>");
                e.preventDefault();    
                // console.log("Не заполнена УЛИЦА, не даю нажать дальше!");  
            }
            if ($('#house_input input').val().length === 0)
            {
                $('#house_input').children("p").remove();
                $('#house_input').append("<p><b>Необходимо заполнить данное поле!<b></p>");
                e.preventDefault();    
                // console.log("Не заполнен ДОМ, не даю нажать дальше!");  
            }

            if ($('#flat_input input').val().length === 0)
            {
                $('#flat_input').children("p").remove();
                $('#flat_input').append("<p><b>Необходимо заполнить данное поле!<b></p>");
                e.preventDefault();    
                // console.log("Не заполнена КВАРТИРА, не даю нажать дальше!");  
            }

            if ($('#add_address_input input').val().length === 0)
            {
                $('#add_address_input').children("p").remove();
                $('#add_address_input').append("<p><b>Необходимо заполнить данное поле!<b></p>");
                e.preventDefault(); 
                // console.log("Не заполнен ДОП.АДРЕС, не даю нажать дальше!");     
            }

            

            

        } 
        else if (($('.optional_address_block').hasClass("hidden")))
        {
            // console.log('Optional new address is NOT visible');
            // ничего не делаем
        }
        

        
    });

    $("select#delivery_address").on('change', function(){
        var option = $(this).val();
        // console.log("some address clicked! " + option );
        if(option == "new"){
            $('.optional_address_block').removeClass('hidden');
        } else {
            $('.optional_address_block').addClass('hidden');
        }

    });

});

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

$('#card_online').click(pay);

$('#courier_cash').click(function(){
    $('#order_payed_online').val(false);
    $('#payment_status').hide();
});
