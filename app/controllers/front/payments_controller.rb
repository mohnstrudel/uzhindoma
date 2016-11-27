class Front::PaymentsController < FrontController
	
	before_action :find_payment, only: [:create, :show]

	def new
		@payment = Payment.new
	end

	def create
		@payment = Payment.new(partner_params)

		if @payment.save
			redirect_to payment_path(@payment)
			flash[:success] = "Успешно создано"
		else
			@payment.errors.full_messages.each do |message| 
  				flash[:danger] = message
  			end
  			render 'new'
  		end
		
	end

	def show
	end

	private

	def find_payment
		@payment = Payment.find(params[:id])
	end

	def payment_params
		params.require(:payment).permit(:price, :alfa_order_id, :alfa_form_url)
	end
end
