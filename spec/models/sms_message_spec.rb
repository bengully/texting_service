require 'rails_helper'

RSpec.describe SmsMessage, type: :model do
    let(:sms_message) { SmsMessage.new(params) }

    context 'when all required params are provided' do
        let(:params) { { phone_number: '5555555555', message: 'Message' } }

        it 'is a valid record' do
            expect(sms_message).to be_valid
        end
    end

    context 'when a phone number is not provided' do
        let(:params) { { message: 'Message' } }

        it 'is invalid' do
            expect(sms_message).not_to be_valid
        end
    end

    context 'when a message is not provided' do
        let(:params) { { phone_number: '5555555555' } }

        it 'is invalid' do
            expect(sms_message).not_to be_valid
        end
    end
end
