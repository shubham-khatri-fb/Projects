class UserCurrency < ApplicationRecord
    enum currency_type:{inr: 0, usd: 1, eur: 2, aud: 3, gbp: 4}, _prefix: true

    belongs_to :user
end
