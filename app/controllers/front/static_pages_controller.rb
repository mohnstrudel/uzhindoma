class Front::StaticPagesController < FrontController
  def home

    instagram_result = InstagramHelper.new
    @instagram = Igram.all
    # debug

    # @instagram = client.tag_recent_media(tags[0].name)
    #debug
    
    if session[:city] == "Москва"
      @current_menus = Menu.no_dessert.current
                            .where(city_id: 1)
                            .sort_by { |menu| menu.category.sortable }

    else
      @current_menus = Menu.no_dessert.current
                            .where(city_id: 2)
                            .sort_by { |menu| menu.category.sortable }

    end


  	@setting = Setting.first

    @roistat = cookies[:roistat_visit]
    puts "Testing cookies"
    puts @roistat.inspect
  end

  def learn_more
  end

  def policy
  end

  def contacts
  end

  def confidentiality
  end

  private

  # Legacy code for learning purpose only
  # def instagram_user_by_id(id)
  #   url = "https://www.instagram.com/query/?q=ig_user(#{id}){id,username,external_url,full_name,profile_pic_url,biography,followed_by{count},follows{count},media{count},is_private,is_verified}"
  #   doc = Nokogiri::HTML(open(url))
  #   return JSON.parse(doc)
  # end

  # def instagram_comments(media_shortcode, comments_amount = 10)
  #   url = "https://www.instagram.com/query/?q=ig_shortcode(#{media_shortcode}){comments.last(#{comments_amount}){count,nodes{id,created_at,text,user{id,profile_pic_url,username,follows{count},followed_by{count},biography,full_name,media{count},is_private,external_url,is_verified}},page_info}}"
  #   doc = Nokogiri::HTML(open(url))
  #   return JSON.parse(doc)
  # end
end
