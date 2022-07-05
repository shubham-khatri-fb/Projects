class AllTransaction < ApplicationRecord
    enum transfer_currency_type: {inr: 0, usd: 1, eur: 2, aud: 3, gbp: 4}, _prefix: true
    enum receive_currency_type: {inr: 0, usd: 1, eur: 2, aud: 3, gbp: 4}, _prefix: true
    

    has_many :user_transactions

end
