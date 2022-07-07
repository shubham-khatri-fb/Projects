class AllTransaction < ApplicationRecord
    enum transfer_currency_type: CURRENCY_TYPE, _prefix: true
    enum receive_currency_type: CURRENCY_TYPE
    

    has_many :user_transactions

end
