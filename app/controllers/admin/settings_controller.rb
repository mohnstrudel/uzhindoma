class Admin::SettingsController < AdminController

	def edit
		@setting = Setting.first
	end

	def update
		@setting = Setting.first

		if @setting.update(settings_params)
			redirect_to edit_admin_setting_path(@setting)
			flash[:success] = "Успешно обновлено"
		else
			render 'edit'
		end
	end

	private

	def settings_params
		params.require(:setting).permit(:vkontakte, :facebook, :instagram, :phone, :order_mail, 
			:out_of_order_begin, :out_of_order_end, :seo_title, :seo_keywords, :seo_description)
	end
end
