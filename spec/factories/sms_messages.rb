FactoryGirl.define do
  factory :sms_message do
    phone_number '5558675309'
    message 'This is a text message'
    message_id SecureRandom.hex

    factory :sms_message_alt do
      phone_number '1111111111'
      message 'This is not the same'
      message_id SecureRandom.hex
    end
  end
end
