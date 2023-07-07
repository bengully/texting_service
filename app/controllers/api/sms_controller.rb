class Api::SmsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def send_message
        SmsMessage.create(sms_params)
        render json: {}
    end
    
    private

    def sms_params
        params.permit(:phone_number, :message)
    end
end
