class Admin::SubscribersController < AdminController
  
  include AdminCrudConcern

  before_action :find_subscriber, only: [:edit, :update, :destroy]

  def index
    @subscribers = index_helper('subscribers')
  end

  def edit
  end

  def new
    @subscriber = Subscriber.new
  end

  def update
    update_helper(@subscriber, "edit_admin_subscriber_path", subscriber_params)
  end

  def create
    @subscriber = Subscriber.new(subscriber_params)
    create_helper(@subscriber, "edit_admin_subscriber_path")
  end

  def destroy
    destroy_helper(@subscriber, "admin_subscribers_path")
  end

  private

  def find_subscriber
    @subscriber = Subscriber.find(params[:id])
  end

  def subscriber_params
    params.require(:subscriber).permit(Subscriber.attribute_names.map(&:to_sym))
  end
end
