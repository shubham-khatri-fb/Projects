class MessageWorker
    include Sidekiq::Worker 

    def perform(msg, phone_number)
        SmsSendService.new.send_message(msg, phone_number)
    end
end