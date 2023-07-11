class Api::SmsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def send_message
        sms_response = SmsProvider.new.call(phone_number: sms_params[:phone_number], message: sms_params[:message])
        sms_message = SmsMessage.new(phone_number: sms_params[:phone_number], message: sms_params[:message])
        sms_message.message_id = sms_response[:message_id]
        
        if sms_message.save
            render json: sms_message
        else
            render json: sms_message.errors, status: :bad_request
        end
    end

    def delivery_status
        sms_message = SmsMessage.find_by(message_id: delivery_params[:message_id])

        if sms_message.update(status: delivery_params[:status])
            render json: sms_message
        else
            render json: sms_message.errors
        end
    end
    
    private

    def sms_params
        params.permit(:phone_number, :message, :callback_url)
    end

    def delivery_params
        params.permit(:status, :message_id)
    end
end
