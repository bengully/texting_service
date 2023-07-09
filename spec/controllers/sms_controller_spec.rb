require 'rails_helper'

RSpec.describe Api::SmsController, type: :controller do
   describe 'send_message' do 
        it 'creates an sms message record' do
            expect {
                post :send_message, params: { phone_number: '111-111-1111', message: 'I am a message'} 
            }.to change(SmsMessage, :count).by(1)
        end
   end
end