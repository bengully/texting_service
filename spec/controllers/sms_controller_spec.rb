require 'rails_helper'

RSpec.describe Api::SmsController, type: :controller do
   describe 'send_message' do 
        let(:message_id) { SecureRandom.hex }

        before do
            stub_request(:post, ENV['PROVIDER']).to_return(status: 200, body: { message_id: message_id }.to_json)
        end

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

   describe 'delivery_status' do
        let(:sms_message) { create(:sms_message) }
        let(:message_id) { sms_message.message_id }

        it 'updates the sms record with the corresponding message id' do
            post :delivery_status, params: { sm: { status: 'delivered', message_id: message_id } }

            expect(response.status).to eq 200
            expect(sms_message.reload.status).to eq 'delivered'
        end
   end
end