module FrontHelper

	def nav_link(link_text, link_path)
      class_name = current_page?(link_path) ? 'active' : ''

  		content_tag(:li, :class => class_name) do
    		link_to link_text, link_path, method: :get
  		end
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


end
