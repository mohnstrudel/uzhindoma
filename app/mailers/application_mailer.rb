class ApplicationMailer < ActionMailer::Base
  default from: "Бот Ужин Дома <sitebot@uzhindoma.ru>"
  layout 'mailer'

  def notify_if_multiple_bitrix_users(phone, client_data)
    @phone = phone
    @client_data = client_data
    mail to: Setting.first.order_mail, subject: 'Несколько пользователей для одного телефона найдено!'
  end

  def notify_feedback(feedback)
    @feedback = feedback
    if Rails.env.production?
      to_mail = "lena@uzhindoma.ru"
    else
      to_mail = Setting.first.order_mail
    end
    mail to: to_mail, subject: "Новый отзыв на сайте"
  end
end
