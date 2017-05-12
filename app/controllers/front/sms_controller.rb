class Front::SmsController < FrontController

  def process_sms
    logger.debug "Inspecting SMS params"
    logger.debug params.inspect
  end
end