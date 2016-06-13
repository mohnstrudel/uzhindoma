class Admin::JobtitlesController < AdminController

	before_action :find_jobtitle, only: [:edit, :update]
	
	def index
		@jobtitles = Jobtitle.all
	end

	def show
	end

	def edit
	end

	def new
		@jobtitle = Jobtitle.new
	end

	def create
		@jobtitle = Jobtitle.new(jobtitle_params)
		@jobtitle.slug = @jobtitle.name.to_slug.transliterate(:russian).to_s.downcase
		
		if @jobtitle.save
  			redirect_to admin_jobtitles_path
      		flash[:success] = "Успешно создано"
  		else
  			render 'new'
  		end
	end

	def update
		@jobtitle.slug = @jobtitle.name.to_slug.transliterate(:russian).to_s.downcase
		
		if @jobtitle.update(jobtitle_params)
  			redirect_to edit_admin_jobtitle_path(@jobtitle)
			flash[:success] = "Успешно обновлено"
  		else
  			render 'edit'
  		end
	end

	private

	def find_jobtitle
		@jobtitle = Jobtitle.find(params[:id])
	end

	def jobtitle_params
		params.require(:jobtitle).permit(:name, :slug)
	end
end
