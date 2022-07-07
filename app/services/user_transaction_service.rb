class UserTransactionService
 
    def deduct_money(user, currency_type, amount)
        if amount.to_d == 0
            raise CustomException::InvalidTransferAmount.new "Amount cannot be 0"
        end
        currency = nil
        currency = user.user_currencies.find_by(currency_type: currency_type)
        if currency.nil?
            user.user_currencies.create!(amount: 0, currency_type: currency_type)
            currency = user.user_currencies.find_by(user_id: user_id, currency_type: currency_type)
        end
        currency.amount = currency.amount - amount.to_d
        currency.save!

    end

    def add_money(user, currency_type, amount)
        if amount.to_d == 0
            raise CustomException::InvalidTransferAmount.new "Amount cannot be 0"
        end
        currency =  nil
        currency = user.user_currencies.find_by(currency_type: currency_type)
        if currency.nil?
            user.user_currencies.create!(amount: 0, currency_type: currency_type)
            currency = user.user_currencies.find_by(currency_type: currency_type)
        end
        currency.amount = currency.amount + amount.to_d
        currency.save!
    end

    def check_sufficient_balance_to_transfer(user, currency_type, amount)
        if amount.to_d == 0
            raise CustomException::InvalidTransferAmount.new "Amount cannot be 0"
        end
        currency = nil
        currency = user.user_currencies.find_by(currency_type: currency_type)
        if currency.nil?
            user.user_currencies.create!(amount: 0, currency_type: currency_type)
            currency = user.user_currencies.find_by(user_id: user, currency_type: currency_type)
        end 
        if currency.amount < amount.to_f
            raise CustomException::Validaton.new "Insufficient money to make transaction !"
        end
    end

    def all_transaction(user, params)
        @all_transaction = UserTransaction.joins(:all_transaction).filter(user,params).select('user_transactions.*','all_transactions.*').page(params[:pages]).per(params[:per_page])
    end


    def make_transaction(current_user, params)
        if params[:receiver].nil? or params[:sender_currency_type].nil? or params[:receiver_currency_type].nil? or params[:amount].nil? 
            raise CustomException::Validaton.new "Required Parameters are missing"
        end
        ActiveRecord::Base.transaction do
            sender = current_user
            receiver = User.find(params[:receiver])
            check_sufficient_balance_to_transfer(sender, params[:sender_currency_type], params[:amount])
            conversion_rate = RedisService.get_conversion_rate(params[:receiver_currency_type])/RedisService.get_conversion_rate(params[:sender_currency_type]) 
            receiver_money = params[:amount].to_f * conversion_rate
            add_money(receiver, params[:receiver_currency_type], receiver_money)
            deduct_money(sender, params[:sender_currency_type], params[:amount])
            transaction = AllTransaction.create!(conversion_rate: conversion_rate, amount_transfer: params[:amount], transfer_currency_type: params[:sender_currency_type], receive_currency_type: params[:receiver_currency_type])
            UserTransaction.create!(user_id: sender.id, all_transaction_id: transaction.id, user_id_transaction_made: receiver.id, transaction_type: :SEND)
            UserTransaction.create!(user_id: receiver.id, all_transaction_id: transaction.id, user_id_transaction_made: sender.id, transaction_type: :RECEIVED)
            message = "Dummy message : #{receiver_money} #{params[:receiver_currency_type].upcase} has been credited to account having user id #{receiver.id}"
            MessageWorker.perform_async(message, receiver.id)
            message = "Dummy message : #{params[:amount]} #{params[:sender_currency_type].upcase} has been debited from account having user id #{sender.id}"
            MessageWorker.perform_async(message, sender.id)
        end
    end

    def deposit_money(user, params)
        if params[:currency_type].nil?  or params[:amount].nil? 
            raise CustomException::Validaton.new "Reqired Parameters are missing"
        end
        ActiveRecord::Base.transaction do
            add_money(user, params[:currency_type], params[:amount])
            transaction = AllTransaction.create!(conversion_rate: 1, amount_transfer: params[:amount], transfer_currency_type: params[:currency_type], receive_currency_type: params[:currency_type])
            user_transaction = UserTransaction.create!(user_id: user.id, all_transaction_id: transaction.id, user_id_transaction_made: user.id, transaction_type: :DEPOSIT)
            message = "Dummy message : #{params[:amount]} #{params[:currency_type].upcase} has been deposited to account having user id #{user.id}"
            MessageWorker.perform_async(message, user.phone_number)
        end
    end

    def withdrawal_money(user, params)
        if params[:currency_type].nil? or params[:amount].nil? 
            raise CustomException::Validaton.new "Reqired Parameters are missing"
        end
        ActiveRecord::Base.transaction do
            check_sufficient_balance_to_transfer(user, params[:currency_type], params[:amount])
            deduct_money(user, params[:currency_type], params[:amount])
            transaction = AllTransaction.create!(conversion_rate: 1, amount_transfer: params[:amount], transfer_currency_type: params[:currency_type], receive_currency_type: params[:currency_type])
            UserTransaction.create!(user_id: user.id, all_transaction_id: transaction.id, user_id_transaction_made: user.id, transaction_type: :WITHDRAWAL)
            message = "Dummy message : #{params[:amount]} #{params[:currency_type].upcase} has been withdrawal from account having user id #{user.id}"
            MessageWorker.perform_async(message, user.phone_number)
        end
    end


    def change_currency(params)
        if params[:sender_currency_type].nil? or params[:received_currency_type].nil? or params[:amount].nil? 
            raise CustomException::Validaton.new "Reqired Parameters are missing"
        end
        ActiveRecord::Base.transaction do
            @user_service.check_sufficient_balance_to_transfer(user, params[:sender_currency_type], params[:amount])
            conversion_rate = RedisService.get_conversion_rate(params[:received_currency_type]) / RedisService.get_conversion_rate(params[:sender_currency_type]) 
            receive_money = params[:amount].to_f * conversion_rate
            add_money(user, params[:received_currency_type], receive_money)
            deduct_money(user, params[:sender_currency_type], params[:amount])
            transaction = AllTransaction.create!(conversion_rate: 1, amount_transfer: params[:amount], transfer_currency_type: params[:sender_currency_type], receive_currency_type: params[:received_currency_type])
            UserTransaction.create!(user_id: user.id, all_transaction_id: transaction.id, user_id_transaction_made: user.id, transaction_type: :CHANGE_CURRENCY)
            message = "Dummy message : #{params[:amount]} #{params[:sender_currency_type].upcase} has been converted to #{receive_money} #{params[:received_currency_type].upcase} from account having user id #{user.id}"
            MessageWorker.perform_async(message, user.phone_number)
        end
    end

end