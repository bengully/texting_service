require 'rails_helper'

RSpec.describe SmsMessage, type: :model do
    let(:sms_message) { SmsMessage.new(params) }

    it 'saves with default status of pending' do
        expect(create(:sms_message).status).to eq 'pending'
    end

    context 'when all required params are provided' do
        let(:params) { { phone_number: '5555555555', message: 'Message', message_id: '1a2b3c' } }

        it 'is a valid record' do
            expect(sms_message).to be_valid
        end
    end

    context 'when a phone number is not provided' do
        let(:params) { { message: 'Message', message_id: '1a2b3c' } }

        it 'is invalid' do
            expect(sms_message).not_to be_valid
        end
    end

    context 'when a message is not provided' do
        let(:params) { { phone_number: '5555555555', message_id: '1a2b3c' } }

        it 'is invalid' do
            expect(sms_message).not_to be_valid
        end
    end

    context 'when a message id is not provided' do
        let(:params) { { phone_number: '5555555555', message: 'Message' } }

        it 'is invalid' do
            expect(sms_message).not_to be_valid
        end
    end
end
