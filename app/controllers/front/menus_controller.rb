class Front::MenusController < FrontController
	before_action :find_menu, only: [:show]

	def show
		@categories = Category.all
		respond_to do |format|
			format.html {}
			format.js {}
		end
	end

	def index
	end

	private

	def find_menu
		@menu = Menu.find(params[:id])
	end
end
