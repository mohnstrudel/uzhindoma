class Front::Users::SessionsController < Devise::SessionsController

  
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    if params[:reset]
      phone = params[:user][:phone]
      # logger.debug("Phone is: #{phone}")

      password = User.generate_password_code
      User.where(phone: phone).update(password: password)

      if phone.length == 17
        
        stripped_phone = phone.gsub(/\s+/, "").gsub(/[()]/, "").gsub(/-/, "")
        encoded_phone = URI.escape(stripped_phone)
        encoded_message = URI.escape("Ваш новый пароль - #{password}.")
        logger.debug("New password for user #{phone} - #{password}")
        
        helpers.send_sms(encoded_phone, encoded_phone)

        flash[:success] = "Пароль успешно выслан."
        redirect_to new_user_session_path
      else
        flash[:danger] = "Телефон введен не верно"
        redirect_to new_user_session_path
      end
    else
      super
    end
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
