class Front::ProfileController < FrontController

	def change_password
		User.change_password
	end

  def generate_password
    User.password_recovery_via_sms(params[:phone])
  end
end
