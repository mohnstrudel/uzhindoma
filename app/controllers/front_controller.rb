class FrontController < ApplicationController
	layout 'front'

  before_action :redirect_if_old

	def fast_order
		@order = Order.new
	end

  protected 

  def redirect_if_old
    if request.host == 'uzhin-doma.ru'
      redirect_to "#{request.protocol}uzhindoma.ru#{request.fullpath}", :status => :moved_permanently 
    elsif request.host == 'www.uzhin-doma.ru'
      redirect_to "#{request.protocol}uzhindoma.ru#{request.fullpath}", :status => :moved_permanently 
    end
  end
end
