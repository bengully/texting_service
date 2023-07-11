FactoryGirl.define do
  factory :sms_message do
    phone_number '5558675309'
    message 'This is a text message'
    message_id SecureRandom.hex
  end
end
