class Front::Users::SessionsController < Devise::SessionsController

  
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    if params[:reset]
      phone = params[:user][:phone]
      # logger.debug("Phone is: #{phone}")

      

      if phone.length == 17

        password = User.generate_password_code
        user = User.where(phone: phone)[0]
        if user.update(password: password)
          logger.debug("New password for user #{user.email} successfully updated")
        else
          logger.debug("Password failed to update")
        end
        
        stripped_phone = phone.gsub(/\s+/, "").gsub(/[()]/, "").gsub(/-/, "")
        encoded_phone = URI.escape(stripped_phone)
        encoded_message = URI.escape("Ваш новый пароль - #{password}.")
        logger.debug("New password for user #{phone} - #{password}")
        
        helpers.send_sms(encoded_phone, encoded_message)

        flash[:success] = "Пароль успешно выслан."
        redirect_to new_user_session_path(phone: phone)
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
