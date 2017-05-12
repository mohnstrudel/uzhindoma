class Sms
  def self.sms_deliver(phone, message)
    # new_url = "https://sms.e-vostok.ru/smsout.php?login=uzhin&password=PvlIjlL0&service=23964&space_force=1&space=UzhinDoma&subno=#{phone}&text=#{message}&dlr-mask=3&dlr-url=http://localhost:3000/process_sms?id=12345&comment=SMS+TO+MYSELF&status=%d&text=%A"
    url = "https://sms.e-vostok.ru/smsout.php?login=uzhin&password=PvlIjlL0&service=23964&space_force=1&space=UzhinDoma&subno=#{phone}&text=#{message}"
    doc = Nokogiri::HTML(open(url))
  end
end