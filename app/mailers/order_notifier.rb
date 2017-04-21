class OrderNotifier < ApplicationMailer
  
  default from: 'Ужин Дома <confirmation@uzhindoma.ru>'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.received.subject
  #


  def received(order)
    @order = order

    
    if order.menu_amount == 5
      @amount_word = "ужинов"
    elsif order.menu_amount == 4
      @amount_word = "ужина"
    else
      @amount_word = "ужин"
    end

    @type = Menu.find(order.menu_id).category.name

    mail to: order.email, subject: "Ваш заказ Ужин Дома"

  end

  def notifyShop(order)
    @order = order
    mail to: Setting.first.order_mail, subject: 'На сайте оставлен заказ'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.shipped.subject
  #
  def out_of_order(phone)
    @phone = phone
    mail to: Setting.first.order_mail, subject: "На сайте был оставлен заказа когда списки были закрыты"
  end
end
