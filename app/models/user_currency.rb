class UserCurrency < ApplicationRecord
    enum currency_type: CURRENCY_TYPE , _prefix: true

    belongs_to :user
end
