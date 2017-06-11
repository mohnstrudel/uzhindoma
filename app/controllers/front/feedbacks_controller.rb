class Front::FeedbacksController < ApplicationController
  
  def create
    @feedback = Feedback.new(feedback_params)
    respond_to do |format|
      if @feedback.save
        format.js
        format.json { render json: @feedback.to_json }

        ApplicationMailer.delay(queue: "feedbacks").notify_feedback(@feedback)
      else
        format.html { render 'new'} ## Specify the format in which you are rendering "new" page
        format.json { render json: @feedback.errors } ## You might want to specify a json format as well
      end
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(Feedback.attribute_names.map(&:to_sym))
  end
end
