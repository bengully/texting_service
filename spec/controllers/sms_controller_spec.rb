require 'rails_helper'

RSpec.describe Api::SmsController, type: :controller do
   before do
    allow(LoadBalancer).to receive(:check_load).and_return(ENV['PROVIDER']) 
   end

   describe 'send_message' do 
        let(:message_id) { SecureRandom.hex }

        context 'when the sms provider response is successful' do
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

            context 'but the response contains no message id' do
                before do
                    stub_request(:post, ENV['PROVIDER']).to_return(status: 200, body: { message_id: nil }.to_json)
                end

                it 'does not successfully create an sms message record' do
                    expect {
                        post :send_message, params: { phone_number: '111-111-1111', message: 'I am a message' }
                    }.not_to change(SmsMessage, :count)
                    expect(response.status).to eq 400
                end
            end
        end

        context 'when the sms provider response is not successful' do
            before do
                stub_request(:post, ENV['PROVIDER']).to_return(status: 500, body: { error: 'There was an error' }.to_json)
            end

            context 'and the backup provider is also unsuccessful' do
                before do
                    stub_request(:post, ENV['PROVIDER_BACKUP']).to_return(status: 500, body: { error: 'There was an error' }.to_json)
                end

                it 'does not successfully create an sms message record' do
                    expect {
                        post :send_message, params: { phone_number: '111-111-1111', message: 'I am a message' } 
                    }.not_to change(SmsMessage, :count)
                    expect(response.status).to eq 500
                end
            end

            context 'and the backup provider is successful' do
                before do
                    stub_request(:post, ENV['PROVIDER_BACKUP']).to_return(status: 200, body: { message_id: message_id }.to_json)
                end

                it 'creates an sms message record' do
                    expect {
                        post :send_message, params: { phone_number: '111-111-1111', message: 'I am a message' }
                    }.to change(SmsMessage, :count).by(1)
                    expect(response.status).to eq 200
                end
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