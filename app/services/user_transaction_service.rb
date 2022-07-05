class UserTransactionService
    def initialize
        @user_service = UserService.new
    end


    def all_transaction(params)
        user = @user_service.get_user(params[:user_id])
        @all_transaction = UserTransaction.joins(:all_transaction).filter(params).select('user_transactions.*','all_transactions.*')

    end


    def make_transaction(params)
        if params[:sender].nil? or params[:receiver].nil? or params[:sender_currency_type].nil? or params[:receiver_currency_type].nil? or params[:amount].nil? 
            raise CustomException::RequiredParametersAreMissing
        end
        ActiveRecord::Base.transaction do
            sender = @user_service.get_user(params[:sender])
            receiver = @user_service.get_user(params[:receiver])
            @user_service.check_sufficient_balance_to_transfer(sender, params[:sender_currency_type], params[:amount])
            conversion_rate = RedisService.get_conversion_rate(params[:receiver_currency_type]) /    RedisService.get_conversion_rate(params[:sender_currency_type]) 
            receiver_money = params[:amount].to_f * conversion_rate
            @user_service.add_money(receiver, params[:receiver_currency_type], receiver_money)
            @user_service.deduct_money(sender, params[:sender_currency_type], params[:amount])
            transaction = AllTransaction.create!(conversion_rate: conversion_rate, amount_transfer: params[:amount], transfer_currency_type: params[:sender_currency_type], receive_currency_type: params[:receiver_currency_type])
            UserTransaction.create!(user_id: sender.id, all_transaction_id: transaction.id, user_id_transaction_made: receiver.id, transaction_type: :SEND)
            UserTransaction.create!(user_id: receiver.id, all_transaction_id: transaction.id, user_id_transaction_made: sender.id, transaction_type: :RECEIVED)
            message = "Dummy message : #{receiver_money} #{params[:receiver_currency_type].upcase} has been credited to account having user id #{receiver.id}"
            MessageWorker.perform_async(message, receiver.id)
            message = "Dummy message : #{params[:amount]} #{params[:sender_currency_type].upcase} has been debited from account having user id #{sender.id}"
            MessageWorker.perform_async(message, sender.id)
        end
    end

    def deposit_money(params)
        if params[:user_id].nil? or params[:currency_type].nil?  or params[:amount].nil? 
            raise CustomException::RequiredParametersAreMissing
        end
        ActiveRecord::Base.transaction do
            user = @user_service.get_user(params[:user_id])
            @user_service.add_money(user, params[:currency_type], params[:amount])
            transaction = AllTransaction.create!(conversion_rate: 1, amount_transfer: params[:amount], transfer_currency_type: params[:currency_type], receive_currency_type: params[:currency_type])
            user_transaction = UserTransaction.create!(user_id: user.id, all_transaction_id: transaction.id, user_id_transaction_made: user.id, transaction_type: :DEPOSIT)
            message = "Dummy message : #{params[:amount]} #{params[:currency_type].upcase} has been deposited to account having user id #{user.id}"
            MessageWorker.perform_async(message, user.phone_number)
        end
    end

    def withdrawal_money(params)
        if params[:user_id].nil? or params[:currency_type].nil? or params[:amount].nil? 
            raise CustomException::RequiredParametersAreMissing
        end
        ActiveRecord::Base.transaction do
            user = @user_service.get_user(params[:user_id])
            @user_service.check_sufficient_balance_to_transfer(user, params[:currency_type], params[:amount])
            @user_service.deduct_money(user, params[:currency_type], params[:amount])
            transaction = AllTransaction.create!(conversion_rate: 1, amount_transfer: params[:amount], transfer_currency_type: params[:currency_type], receive_currency_type: params[:currency_type])
            UserTransaction.create!(user_id: user.id, all_transaction_id: transaction.id, user_id_transaction_made: user.id, transaction_type: :WITHDRAWAL)
            message = "Dummy message : #{params[:amount]} #{params[:currency_type].upcase} has been withdrawal from account having user id #{user.id}"
            MessageWorker.perform_async(message, user.phone_number)
        end
    end


    def change_currency(params)
        if params[:user_id].nil? or params[:sender_currency_type].nil? or params[:received_currency_type].nil? or params[:amount].nil? 
            raise CustomException::RequiredParametersAreMissing
        end
        ActiveRecord::Base.transaction do
            user = @user_service.get_user(params[:user_id])
            @user_service.check_sufficient_balance_to_transfer(user, params[:sender_currency_type], params[:amount])
            conversion_rate = RedisService.get_conversion_rate(params[:received_currency_type]) / RedisService.get_conversion_rate(params[:sender_currency_type]) 
            receive_money = params[:amount].to_f * conversion_rate
            @user_service.add_money(user, params[:received_currency_type], receive_money)
            @user_service.deduct_money(user, params[:sender_currency_type], params[:amount])
            transaction = AllTransaction.create!(conversion_rate: 1, amount_transfer: params[:amount], transfer_currency_type: params[:sender_currency_type], receive_currency_type: params[:received_currency_type])
            UserTransaction.create!(user_id: user.id, all_transaction_id: transaction.id, user_id_transaction_made: user.id, transaction_type: :CHANGE_CURRENCY)
            message = "Dummy message : #{params[:amount]} #{params[:sender_currency_type].upcase} has been converted to #{receive_money} #{params[:received_currency_type].upcase} from account having user id #{user.id}"
            MessageWorker.perform_async(message, user.phone_number)
        end
    end

end