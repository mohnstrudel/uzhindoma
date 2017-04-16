class Front::Users::SessionsController < Devise::SessionsController

  
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
      
      # helpers.send_sms(encoded_phone, encoded_message)

    super
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

  def after_sign_in_path_for(resource)
    puts "#--------------#"
    puts "User successfully logged in!"
    puts "#--------------#"
    new_order_path
    # Тут перенаправляем на страницу заказа
    # if params[:menu_id].blank?
    #   edit_user_registration_path
    # else
    #   new_order_path(menu_id: params[:menu_id], person_amount: params[:person_amount], menu_amount: params[:menu_amount], add_dessert: params[:add_dessert])
    # end
  end
end
