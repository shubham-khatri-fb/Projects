class UserTransactionsController < ApplicationController
    #skip_before_action :verify_authenticity_token
    #skip_before_action :authorized, only: [:all_transaction, :download_excel]
    before_action :verify_user

    def initialize
        @user_transaction = UserTransactionService.new
    end


    def all_transaction
        @transaction = @user_transaction.all_transaction(params)
    end

    def download_excel
        @item = @user_transaction.all_transaction(params)
        respond_to do |format|
            format.xlsx {
                response.headers['Content-Disposition'] = 'attachment; filename="transaction_history.xlsx"'
              }
        end
    end

    def make_transaction
        @user_transaction.make_transaction(params)
        render json: {message:  "Successfully made the transfer"}
    end

    def deposit_money
        @user_transaction.deposit_money(params)
        render json: {message:  "Successfully deposit money"}
    end

    def withdrawal_money
        @user_transaction.withdrawal_money(params)
        render json:{message: "Successfully withdraw money"}
    end

    def change_currency
        @user_transaction.change_currency(params)
        render json: {message:  "Succesfully change the currency"}
    end

    private

    def verify_user
        if @user.id != params[:sender] and @user.id != params[:user_id].to_i
            render json: {message: "User don't have Permission for the operation"}, status: 421
        end
    end

end