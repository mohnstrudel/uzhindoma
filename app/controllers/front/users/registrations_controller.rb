class Front::Users::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  def edit
    if Rails.env.production?
      @text = Bitrix.get_refresh_token
      # If a user is existant inside Bitrix, we save his bitrix id to database,
      # to query faster next times

      if current_user.bitrix_id.nil?
        unless current_user.phone.nil?
          bitrix_id = Bitrix.check_if_user_exists(current_user.phone)
        end

        # We simply do nothing if there is no phone number and user is new

        unless bitrix_id.nil?
          current_user.update(bitrix_id: bitrix_id)
        end

      elsif current_user.orders_updated == false
        current_user.update_orders_from_bitrix(current_user.bitrix_id)
        @orders = current_user.orders.order('created_at DESC')

      else
        # orders = Bitrix.get_users_orders(current_user.bitrix_id)
        begin
          @orders = current_user.orders.order('created_at DESC')
        rescue => e
          @orders = nil
          logger.info "Error for user orders"
          logger.info "User - #{current_user}, error: #{e.message}"
        end
      end
    end
      # @address = current_user.addresses.build

    super
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end


  def after_update_path_for(resource)
    edit_user_registration_path
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :second_name, :phone, :street, :house_number,
      :flat_number, :delivery_region, :email, :city, :additional_address,
      addresses_attributes: [:title, :street, :house_number, :flat_number, :delivery_region, :city, :additional_address, :user_id, :main, :id, :_destroy]
      ])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
