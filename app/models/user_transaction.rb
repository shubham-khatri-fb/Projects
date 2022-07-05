class UserTransaction < ApplicationRecord
    enum transaction_type:{
        DEPOSIT: 0,
        WITHDRAWAL: 1,
        CHANGE_CURRENCY: 2,
        SEND: 3,
        RECEIVED: 4
    }, _prefix: true


    belongs_to :user
    belongs_to :all_transaction, optional: true

    scope :with_transaction_type, ->(transaction_type) {where("transaction_type = ?", UserTransaction.transaction_types[transaction_type])}
    scope :between_date, ->(from, to) {where("DATE(all_transactions.created_at) BETWEEN ? AND ?", from, to)}
    scope :with_user, ->(user_id) {where("user_id = ?", user_id)}

    scope :filter, ->(params){
        result = with_user(params[:user_id])
        result = result.with_transaction_type(params[:transaction_type]) if params[:transaction_type].present?
        result = result.between_date(params[:from_date], params[:to_date]) if params[:from_date].present? and params[:to_date].present?
        return result
    }

end
