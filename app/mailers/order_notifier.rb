class OrderNotifier < ApplicationMailer
  
  default from: 'Ужин Дома <confirmation@uzhindoma.ru>'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.received.subject
  #
  def received(order)
    @order = order

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
  def shipped
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
