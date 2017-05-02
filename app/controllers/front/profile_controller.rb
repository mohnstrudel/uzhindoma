class Front::ProfileController < FrontController

	def change_password
		logger.debug "This is Patrick with params: #{params}"
	end

  def generate_password
    User.password_recovery_via_sms(params[:phone])
  end
end
