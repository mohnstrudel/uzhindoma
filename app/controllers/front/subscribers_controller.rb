class Front::SubscribersController < FrontController
  
  def create
    @subscriber = Subscriber.new(subscriber_params)
    respond_to do |format|
      if @subscriber.save
        format.js
        format.json { render json: @subscriber.to_json }

        # ApplicationMailer.delay(queue: "feedbacks").notify_feedback(@feedback)
      else
        format.js { render partial: 'fail'} ## Specify the format in which you are rendering "new" page
        format.json { render json: @subscriber.errors } ## You might want to specify a json format as well
      end
    end
  end

  private

  def subscriber_params
    params.require(:subscriber).permit(Subscriber.attribute_names.map(&:to_sym))
  end
end
