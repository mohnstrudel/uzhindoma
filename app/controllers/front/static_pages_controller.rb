class Front::StaticPagesController < FrontController
  def home
    
    instagram_result = InstagramHelper.new
    @instagram = instagram_result.by_tag("ужиндома_тестдрайв")

    # @instagram = client.tag_recent_media(tags[0].name)
    # debug
  	@current_menus = Menu.current

  	@setting = Setting.first
  end

  def learn_more
  	@carriers = Employee.profession("kurer")
  	@employees = Employee.all
    @partners = Partner.all
  end
end
