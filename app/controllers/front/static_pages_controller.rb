class Front::StaticPagesController < FrontController
  def home
    token = "3402426957.237f14b.bb3b43cb6d74479782d37d9742b786ea"
  	client = Instagram.client(access_token: token)
  	# user = client.user
    # tags = client.tag_search('unfiltered')
    tags = URI.escape("ужиндома_тестдрайв")
    url = "https://api.instagram.com/v1/tags/#{tags}/media/recent?access_token=#{token}"
  	doc = Nokogiri::HTML(open(url))
    
    @instagram = JSON.parse(doc)["data"]

    # @instagram = client.tag_recent_media(tags[0].name)
    # debug
  	@current_menus = Menu.current

  	@setting = Setting.first
  end

  def learn_more
  	@carriers = Employee.profession("kurer")
  	@employees = Employee.all
  end
end
