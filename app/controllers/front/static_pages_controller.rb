class Front::StaticPagesController < FrontController
  def home
  	client = Instagram.client(access_token: "3402426957.237f14b.bb3b43cb6d74479782d37d9742b786ea")
  	# user = client.user
  	@instagram = client.user_recent_media

  	@current_menus = Menu.current

  	@setting = Setting.first
  end

  def learn_more
  end
end
