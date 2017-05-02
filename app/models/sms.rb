class Sms
  def self.sms_deliver(phone, message)
    url = "https://sms.e-vostok.ru/smsout.php?login=uzhin&password=PvlIjlL0&service=23964&space_force=1&space=UzhinDoma&subno=#{phone}&text=#{message}"
    doc = Nokogiri::HTML(open(url))
  end
end