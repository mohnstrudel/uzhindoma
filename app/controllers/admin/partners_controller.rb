class Admin::PartnersController < AdminController
		before_action :find_partner, only: [:edit, :update]
	

	def new
		@partner = Partner.new
	end

	def index
		@partners = Partner.order(created_at: :desc)
	end

	def edit
	end

	def create
		@partner = Partner.new(partner_params)

		if @partner.save
			redirect_to admin_partners_path
			flash[:success] = "Успешно создано"
		else
			@partner.errors.full_messages.each do |message| 
  				flash[:danger] = message
  			end
  			render 'new'
  		end
	end

	def update

		if @partner.update(partner_params)
			redirect_to edit_admin_partner_path(@partner)
			flash[:success] = "Успешно обновлено"
		else
			@partner.errors.full_messages.each do |message| 
  				flash[:danger] = message
  			end
  			render 'edit'
  		end
	end

	private


	def partner_params
		params.require(:partner).permit(:name, :picture)
	end

	def find_partner
		@partner = Partner.find(params[:id])
	end
end
