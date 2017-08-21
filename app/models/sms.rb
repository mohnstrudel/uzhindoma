class Sms
  def self.sms_deliver(phone, message)
    test = CGI.escape("test comment")
    sub_url = CGI.escape("http://uzhin-doma.ru/process_sms?id=12399&comment=#{test}&status=%d&text=%A")
    new_url = "https://sms.e-vostok.ru/smsout.php?login=uzhin&password=PvlIjlL0&service=23964&space_force=1&space=UzhinDoma&subno=#{phone}&text=#{message}&dlr-mask=3&dlr-url=#{sub_url}"
    # url = "https://sms.e-vostok.ru/smsout.php?login=uzhin&password=PvlIjlL0&service=23964&space_force=1&space=UzhinDoma&subno=#{phone}&text=#{message}"
    url = new_url
    doc = Nokogiri::HTML(open(url))
    Rails.logger.debug "SMS class called with url params:"
    Rails.logger.debug url
  end
end