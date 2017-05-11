class Admin::DashboardController < AdminController
  def index
    @orders_current_weak = Order.current_weak
    @orders_last_weak = Order.last_weak
  end
end
