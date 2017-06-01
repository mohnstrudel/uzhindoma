class Front::SmsController < FrontController

  def process_sms
    respond_to do |format|
      format.json {
        render json: params.inspect
      }
    end
    logger.debug "Inspecting SMS params"
    logger.debug params.inspect
  end
end