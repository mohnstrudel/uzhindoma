class Admin::FeedbacksController < AdminController

  def index
    @feedbacks = Feedback.all.order(created_at: :desc).paginate(:page => params[:page], :per_page => 30)
  end

  def show
    @feedback = Feedback.find(params[:id])
  end
end
