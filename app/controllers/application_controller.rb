class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_city

  layout :layout_by_resource

  def set_city
    #request.location.city #get the user location by default
    unless session[:city].present?
      session[:city] = "Москва"
    end
    #change to user specificied location
    if params[:city].present?
      session[:city] = params[:city]
    end
  end

  protected

  def layout_by_resource
    if devise_controller?
      "front"
    end
  end
end
