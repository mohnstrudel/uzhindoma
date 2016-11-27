class Front::Users::SessionsController < Devise::SessionsController

  
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    if params[:reset]
      phone = params[:user][:phone]
      # logger.debug("Phone is: #{phone}")
      new_password = Array.new
      5.times do
        new_password << rand(9)  
      end
      password = new_password.join("")
      User.where(phone: phone).update(password: password)

      stripped_phone = phone.gsub(/\s+/, "").gsub(/[()]/, "").gsub(/-/, "")
      encoded_phone = URI.escape(stripped_phone)
      encoded_message = URI.escape("Ваш новый пароль - #{password}.")
      # logger.debug("New password for user #{phone} - #{password}")
      # url = "https://sms.e-vostok.ru/smsout.php?login=uzhin&password=PvlIjlL0&service=23964&space_force=1&space=UzhinDoma&subno=#{encoded_phone}&text=#{encoded_message}"
      # doc = Nokogiri::HTML(open(url))
      flash[:success] = "Пароль успешно выслан."
      redirect_to new_user_session_path
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
