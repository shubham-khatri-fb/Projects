require 'rubygems'
require 'twilio-ruby'

class SmsSendService 

# Find your Account SID and Auth Token at twilio.com/console
# and set the environment variables. See http://twil.io/secure

    def send_message(msg, phone_number)
        # account_sid = ENV['TWILIO_ACCOUNT_SID']
        # auth_token = ENV['TWILIO_AUTH_TOKEN']
        account_sid =  ENV["TWILIO_ACCOUNT_SID"]
        auth_token =  ENV["TWILIO_AUTH_TOKEN"]
        @client = Twilio::REST::Client.new(account_sid, auth_token)

        message = @client.messages
        .create(
            body: msg,
            from: '+19898001707',
            to: "+91#{phone_number}"
        )

        puts message.sid
    end

end