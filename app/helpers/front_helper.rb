module FrontHelper

  def small_post(index)
    if index > 9
      index_to_check = index[0] + 10
    else
      index_to_check = index + 10
    end

    if (index_to_check % 11 == 0) && ((index_to_check+1) % 12 == 0)
      return true
    else
      return false
    end
  end

  def get_second_blog_element(index)
    if index > 9
      index_to_check = index[0] + 10
    else
      index_to_check = index + 10
    end

    if index_to_check % 12 == 0
      return true
    else
      return false
    end
  end

  def get_inner_blog_class(index)
    if index > 9
      index_to_check = index[0] + 10
    else
      index_to_check = index + 10
    end
    
    case  
    when index_to_check % 10 == 0
      return "g-post-wrapper"
    when index_to_check % 11 == 0
      return "g-post_small"
    when index_to_check % 12 == 0
      return "g-post_small"
    when index_to_check % 15 == 0
      return "g-post-wrapper"
    when index_to_check % 19 == 0
      return "g-post-wrapper"
    when index_to_check % 13 == 0
      return "g-post-wrapper g-post-wrapper_wide"
    when index_to_check % 14 == 0
      return "g-post-wrapper g-post-wrapper_wide"
    when index_to_check % 17 == 0
      return "g-post-wrapper g-post-wrapper_wide"
    when index_to_check % 16 == 0
      return "g-post-wrapper g-post-wrapper_small"
    when index_to_check % 18 == 0
      return "g-post-wrapper g-post-wrapper_small"
    end
  end

  def get_outer_blog_class(index)
    if index > 9
      index_to_check = index[0] + 10
    else
      index_to_check = index + 10
    end
    
    if (index_to_check % 11) == 0 and (index_to_check+1) % 12 == 0
      return "g-post-wrapper g-post-wrapper_small"
    else
      return ""
    end
  end

	def nav_link(link_text, link_path)
      class_name = current_page?(link_path) ? 'g-menu__link_active' : ''

    	link_to link_text, link_path, class: "g-menu__link #{class_name}", method: :get
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

  def settings_helper
    if Setting.first
      return Setting.first
    else
      raise "No setting found. Please create on in the admin panel."
    end
  end

  def site_title
    title = Setting.first.seo_title
    if title.present?
      return title
    else
      return "Ужин Дома"
    end
  end

  def main_keywords
    keywords = Setting.first.seo_keywords
    if keywords
      return keywords.split(",")
    else
      return ""
    end
  end

  def main_description
    desc = Setting.first.seo_description

    return desc
  end

  def navi_user_link_words(user)
    if (user.first_name.present? && user.second_name.present?)
      return "#{user.first_name} #{user.second_name}"
    elsif user.first_name.present?
      return "#{user.first_name}"
    else
      return "Пользователь"
    end
  end

end
