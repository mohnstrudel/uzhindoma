class OrderNotifier < ApplicationMailer
  
  default from: 'Ужин Дома <orders@uzhindoma.ru>'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.received.subject
  #


  def api_send(order)
    # using SendGrid's Ruby Library
    # https://github.com/sendgrid/sendgrid-ruby
    require 'sendgrid-ruby'
    include SendGrid

    from = Email.new(email: 'test@example.com')
    to = Email.new(email: order.mail)
    subject = 'Sending with SendGrid is Fun'
    content = Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: Figaro.env.sendgrid_api_key)
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end


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

    if order.delivery_timeframe
      @delivery_date = "Ближайшее воскресенье - #{order.delivery_timeframe}"
    elsif order.delivery_day && order.delivery_time
      @delivery_date = "#{order.delivery_day} - #{order.delivery_time}"
    else
      @delivery_date = "Ближайшее воскресенье"
    end


    begin
      logger.info "Client confirmation mail to client: #{order.phone} successfully sent."
      mail to: order.email, subject: "Ваш заказ Ужин Дома"
    rescue => e
      logger.info "Client confirmation mail to client: #{order.phone} failed. Error(s): #{e.message}"
    end
  end

  def notifyShop(order)
    @order = order

    if order.delivery_timeframe
      @delivery_date = "Ближайшее воскресенье - #{order.delivery_timeframe}"
    elsif order.delivery_day && order.delivery_time
      @delivery_date = "#{order.delivery_day} - #{order.delivery_time}"
    end
    
    begin
      mail to: Setting.first.order_mail, subject: 'На сайте оставлен заказ'
      logger.info "Shop confirmation for order No. #{order.id} and client #{order.phone} successfully sent."
    rescue => e
      logger.info "Shop confirmation for order No. #{order.id} and client #{order.phone} failed. Error(s): #{e.message}"
    end
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
