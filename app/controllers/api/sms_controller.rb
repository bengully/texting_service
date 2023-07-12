class Api::SmsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        sms_messages = sms_params[:phone_number].nil? ? SmsMessage.all : SmsMessage.where(phone_number: sms_params[:phone_number])
        sms_messages = sms_messages.order(:created_at).limit(10).offset(page)
        render json: sms_messages
    end

    def send_message
        sms_response = SmsProvider.call(phone_number: sms_params[:phone_number], message: sms_params[:message])
        sms_message = SmsMessage.new(phone_number: sms_params[:phone_number], message: sms_params[:message])
        
        if sms_response.status == 200
            sms_message.message_id = JSON.parse(sms_response.body)['message_id']

            if sms_message.save
                render json: sms_message
            else
                render json: sms_message.errors, status: :bad_request
            end
        else
            render json: { error: 'There was an issue processing your request. Please try again.' }, status: sms_response.status
        end
    end

    def delivery_status
        sms_message = SmsMessage.find_by(message_id: delivery_params[:message_id])

        if sms_message&.update(status: delivery_params[:status])
            render json: sms_message
        else
            render json: { errors: 'No message with the provided Message ID was found.' }
        end
    end
    
    private

    def sms_params
        params.permit(:phone_number, :message, :page)
    end

    def delivery_params
        params.require(:sm).permit(:status, :message_id)
    end

    def page
        page = sms_params[:page].to_i

        if page <= 1
            return 0
        else
            return (page - 1) * 10
        end

    end
end
