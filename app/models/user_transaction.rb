class UserTransaction < ApplicationRecord
    enum transaction_type: TRANSACTION_TYPE


    belongs_to :user
    belongs_to :all_transaction, optional: true

    scope :with_transaction_type, ->(transaction_type) {where(transaction_type: UserTransaction.transaction_types[transaction_type])}
    scope :between_date, ->(from, to) {where("all_transactions.created_at::DATE >= ? AND all_transactions.created_at::DATE <= ?", from, to)}
    scope :with_user, ->(user_id) {where(user_id: user_id)}
    scope :with_date, ->(date) { where("all_transactions.created_at::DATE = ?",date)} 

    scope :filter, ->(current_user,params){
        result = with_user(current_user.id)
        result = result.with_transaction_type(params[:transaction_type]) if params[:transaction_type].present?
        result = result.between_date(params[:from_date], params[:to_date]) if params[:from_date].present? and params[:to_date].present?
        result = result.with_date(params[:date]) if params[:date].present? and !params[:from_date].present? and !params[:to_date].present?
        return result
    }

end
