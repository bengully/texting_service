class SmsProvider
    def self.call(phone_number:, message:)
        new.call(phone_number: phone_number, message: message)
    end

    def call(phone_number:, message:)
        @phone_number = phone_number
        @message = message

        return sms_provider_call
    end

    private

    def params
        { to_number: @phone_number, message: @message, callback_url: "https://#{ENV['HOST']}/api/delivery_status" }
    end

    def provider
        ENV['PROVIDER']
    end

    def provider_backup
        ENV['PROVIDER_BACKUP']
    end

    def sms_provider_call
        url = LoadBalancer.check_load(light_load: provider, heavy_load: provider_backup)
        response = Faraday.post(url, params.to_json)
        
        if response.status == 500
            backup_url = ([provider, provider_backup] - [url]).first
            return Faraday.post(backup_url, params.to_json)
        else
            return response
        end
    end
end