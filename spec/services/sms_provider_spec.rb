require 'rails_helper'

RSpec.describe SmsProvider do 
    let(:message_id) { SecureRandom.hex }

    before do
        stub_request(:post, ENV['PROVIDER']).to_return(status: 200, body: { message_id: message_id }.to_json)
    end

    it 'works' do
        response = SmsProvider.call(phone_number: '5555555555', message: 'Message!')
        
        expect(response.status).to eq 200
        expect(JSON.parse(response.body)['message_id']).to eq message_id
    end
end