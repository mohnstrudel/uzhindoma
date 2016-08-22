module FrontHelper

	def nav_link(link_text, link_path)
  		class_name = current_page?(link_path) ? 'active' : ''

  		content_tag(:li, :class => class_name) do
    		link_to link_text, link_path, method: :get
  		end
	end

	def embed(youtube_url)
    	youtube_id = youtube_url.split("=").last
    	content_tag(:iframe, nil, frameborder: 0, width: 560, height: 315, src: "//www.youtube.com/embed/#{youtube_id}")
  	end
end
