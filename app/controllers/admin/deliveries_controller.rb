class Admin::DeliveriesController < AdminController
  
  include AdminCrudConcern

  before_action :find_delivery, only: [:edit, :update, :destroy]

  def index
    @deliveries = index_helper('deliveries')
  end

  def edit
  end

  def new
    @delivery = Delivery.new
  end

  def update
    update_helper(@delivery, "edit_admin_delivery_path", delivery_params)
  end

  def create
    @delivery = Delivery.new(delivery_params)
    create_helper(@delivery, "edit_admin_delivery_path")
  end

  def destroy
    destroy_helper(@delivery, "admin_deliveries_path")
  end

  private

  def find_delivery
    @delivery = Delivery.find(params[:id])
  end

  def delivery_params
    params.require(:delivery).permit(Delivery.attribute_names.map(&:to_sym).push(
      intervals_attributes: [:id, :value, :_destroy, :delivery_id ]))
  end
end
