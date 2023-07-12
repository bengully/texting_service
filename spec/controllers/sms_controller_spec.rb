require 'rails_helper'

RSpec.describe Api::SmsController, type: :controller do
   before do
    allow(LoadBalancer).to receive(:check_load).and_return(ENV['PROVIDER']) 
   end

   describe 'index' do
        let!(:sms_messages) { create_list(:sms_message, 3) }
        let!(:sms_message_alt) { create(:sms_message_alt) }

        context 'when no params are included' do
            it 'returns the sms_messages' do
                get :index, params: {}

                response_ids = JSON.parse(response.body).map {|message| message['id'] }
                expect(response_ids).to match_array(sms_messages.pluck(:id) << sms_message_alt.id)
            end
        end

        context 'when a phone number is included in the params' do
            it 'returns the sms_messages only for the provided phone number' do
                get :index, params: { phone_number: sms_messages.first.phone_number }

                response_ids = JSON.parse(response.body).map {|message| message['id'] }
                expect(response_ids).to match_array(sms_messages.pluck(:id))
            end
        end

        context 'when a page number is specified in the params' do
            let!(:sms_messages) { create_list(:sms_message, 20) }
            context 'and no phone number is provided' do
                it 'returns 10 message records from the specified page' do
                    get :index, params: { page: 2 }

                    response_ids = JSON.parse(response.body).map {|message| message['id'] }
                    sms_messages_to_match = (sms_messages << sms_message_alt).sort_by { |message| message['created_at'] }

                    expect(response_ids).to match_array(sms_messages_to_match[10,10].pluck(:id))
                end
            end

            context 'and a phone number is provided' do
                it 'returns 10 message records from the specified page filtered by phone number' do
                    get :index, params: { page: 2, phone_number: sms_messages.first.phone_number }

                    response_ids = JSON.parse(response.body).map {|message| message['id'] }

                    expect(response_ids).to match_array(sms_messages.sort_by(&:created_at)[10,10].pluck(:id))
                end
            end
        end


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