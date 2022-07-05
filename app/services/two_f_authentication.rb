require 'authy'
class TwoFAuthentication

    def initialize
        Authy.api_key = ENV["AUTH_API_KEY"]
        Authy.api_uri = 'https://api.authy.com' 
    end

    def register_user(user)
        # Download the helper library from https://github.com/twilio/authy-ruby
        # Your API key from twilio.com/console/authy/applications
        # DANGER! This is insecure. See http://twil.io/secure
        
        #Authy.api_uri = 'https://api.authy.com'

        p user.phone_number
        p user.email
        p Authy.api_key
        authy = Authy::API.register_user(:email => user.email, :cellphone => user.phone_number, :country_code => "91")
        p authy

        if authy.ok?
            user.authy_id = authy.id
            user.save
            return authy
        else
            return authy.errors
        end
    end     


    def send_otp(authy_id)
        response = Authy::API.request_sms(:id => authy_id)
        return response
    end

    def verify_token(authy_id, token_id)
        # Your API key from twilio.com/console/authy/applications
        # DANGER! This is insecure. See http://twil.io/secure
       
        response = Authy::API.verify(:id => authy_id, :token => token_id)

        if response.ok?
            return true
        else
            return false
        end
    end


end