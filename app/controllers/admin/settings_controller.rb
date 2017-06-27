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
		params.require(:setting).permit(Setting.attribute_names.map(&:to_sym))
	end
end
