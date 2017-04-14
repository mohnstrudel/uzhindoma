module FrontHelper

	def nav_link(link_text, link_path)
      class_name = current_page?(link_path) ? 'g-menu__link_active' : ''

    	link_to link_text, link_path, class: "g-menu__link #{class_name}"
	end

	def embed(youtube_url, options = {})
      width = options[:width] || 560
      height = options[:height] || 315
    	youtube_id = youtube_url.split("=").last
    	content_tag(:iframe, nil, frameborder: 0, width: width, height: height, src: "//www.youtube.com/embed/#{youtube_id}")
  end

  def instagram_user_by_image_code(code)
    url = "https://www.instagram.com/p/#{code}/?__a=1"
    JSON.parse( open( "#{url}" ).read )["media"]["owner"]["full_name"]
  end

  def parse_checkbox_array_params(array_as_string)
    value = array_as_string.split(",")[0].gsub(" ","").gsub("[",'').to_i
  end

  def send_sms(phone, message)
    url = "https://sms.e-vostok.ru/smsout.php?login=uzhin&password=PvlIjlL0&service=23964&space_force=1&space=UzhinDoma&subno=#{phone}&text=#{message}"
    doc = Nokogiri::HTML(open(url))
  end

  def settings_helper
    if Setting.first
      return Setting.first
    else
      raise "No setting found. Please create on in the admin panel."
    end
  end

end
