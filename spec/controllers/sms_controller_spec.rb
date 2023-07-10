require 'rails_helper'

RSpec.describe Api::SmsController, type: :controller do
   describe 'send_message' do 
        context 'when all valid params are provided' do
            it 'creates an sms message record' do
                expect {
                    post :send_message, params: { phone_number: '111-111-1111', message: 'I am a message' } 
                }.to change(SmsMessage, :count).by(1)
                expect(response.status).to eq 200
            end
        end

        context 'when all valid params are not provided' do
            it 'does not successfully create an sms message record' do
                expect {
                    post :send_message, params: { message: 'I am a message' } 
                }.not_to change(SmsMessage, :count)
                expect(response.status).to eq 400
            end
        end
   end
end