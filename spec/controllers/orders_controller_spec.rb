require 'rails_helper'


describe Front::OrdersController, type: :controller do

	describe '#new' do
		# Set up dummy menu
		let (:menu) { Menu.create(daterange: "12/12/2012 - 31/12/2012") }

		it "redirects user to sign up page if user is present in the system" do
			user = User.create(name: "Bob", password: "bobspassword", phone: "+7 (903) 227-8874")

			get :new, params: { phone: user.phone }
			expect(response).to redirect_to(new_user_session_path(phone: user.phone))
		end

		it "redirects user to new order page if user is not present in the system" do
			non_present_phone = "+7 (903) 227-8874"

			allow_any_instance_of(Menu).to receive(:calculate_price).and_return("250")

			get :new, params: { phone: non_present_phone, menu_id: menu.id }
			expect(response).to render_template(:new)
		end

	end


	describe '#create_user_if_not_exists_yet' do

		it "creates the user" do
			non_present_phone = "+7 (903) 227-8874"
			non_present_mail = "non@mail.com"
			
			controller.params = ActionController::Parameters.new(order: { email: non_present_mail, phone: non_present_phone })
			
			expect{	
				controller.send(:create_user_if_not_exists_yet, controller.params)
			}.to change { User.count }

		end

		it "does not create additional user if phone is present" do
			user = User.create(name: "Bob", password: "bobspassword", phone: "+7 (903) 227-8874")

			new_users_phone = "+7 (903) 227-8874"

			controller.params = ActionController::Parameters.new(order: { phone: new_users_phone })
			
			expect{	
				controller.send(:create_user_if_not_exists_yet, controller.params)
			}.not_to change { User.count }
		end

		it "sends a sms with password if user is created" do
			@helper = Object.new.extend FrontHelper

			non_present_phone = "+7 (903) 227-8874"
			non_present_mail = "non@mail.com"
			
			controller.params = ActionController::Parameters.new(order: { email: non_present_mail, phone: non_present_phone })
			
			@helper.stub(:send_sms).and_return(true)
		end
	end

	describe '#action_upon_creation' do

		before(:each) do
			allow_any_instance_of(Front::OrdersController).to receive(:check_if_user_exists).and_return(true)
		end
		it "creates a new bitrix LEAD if user is not present" do
			non_present_phone = "+7 (903) 227-88-74"
			controller.params = ActionController::Parameters.new(order: { phone: non_present_phone })
			
			
			# allow(controller).to receive(:check_if_user_exists)
			controller.send(:action_upon_order_creation, controller.params)


			# allow(subject).to receive(:check_if_user_exists).and_return(true)

			# expect(subject).to receive(:create_new_bitrix_lead).with("user", "order")
		end

		it "creates a new bitrix DEAL if user is present" do

		end
	end
end