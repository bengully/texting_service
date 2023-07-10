class Api::SmsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def send_message
        sms_message = SmsMessage.new(sms_params)
        if sms_message.save
            render json: sms_message
        else
            render json: sms_message.errors, status: :bad_request
        end
    end
    
    private

    def sms_params
        params.permit(:phone_number, :message)
    end
end
