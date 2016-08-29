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

  def image_or_default_tag(object, image_model_title, image_field_title, options = {})
    thumb = options[:thumb]
    order = options[:order] || 'first'

    if order == :each
      return image_tag(object.send(image_field_title).url(thumb), class: options[:class])
    elsif object.try(image_model_title)
      if object.send(image_model_title).any?
        return image_tag(object.send(image_model_title).send(order).send(image_field_title).url(thumb), class: options[:class])
      else
        return placeholdit_image_tag "50x50", text: 'Нет картинки', class: options[:class]
      end
    else
      return image_tag(object.send())
    end
        
  end
end
