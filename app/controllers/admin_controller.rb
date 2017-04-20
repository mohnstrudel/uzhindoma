class AdminController < ApplicationController

  before_action :authenticate_admin!, :verify_has_access
	layout "admin"

  private

  def verify_has_access
    (current_admin.nil?) ? redirect_to(root_path) : (redirect_to(edit_admin_registration_path) unless current_admin.has_rights?)
  end
end


  