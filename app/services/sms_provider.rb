class SmsProvider
    def self.call(phone_number:, message:)
        new.call(phone_number: phone_number, message: message)
    end

    def call(phone_number:, message:)
        @phone_number = phone_number
        @message = message

        return Faraday.post(provider, params)
    end

    private

    def params
        { to_number: @phone_number, message: @message, callback_url: "#{ENV['URL']}/api/delivery_status" }
    end

    def provider
        ENV['PROVIDER']
    end

    def provider_backup
        ENV['PROVIDER_BACKUP']
    end
end