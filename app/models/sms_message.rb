class SmsMessage < ApplicationRecord
    validates :phone_number, presence: true
    validates :message, presence: true
end
