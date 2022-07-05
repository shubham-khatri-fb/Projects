class UserService
    
    def get_user(user_id)
        return User.find(user_id)
    end

    def upload_image(params)
        user = self.get_user(params[:user_id])
        user.avatar = params[:image]
        user.save
    end

    def deduct_money(user, currency_type, amount)
        currency = nil
        currency = user.user_currencies.find_by(currency_type: currency_type)
        if currency.nil?
            user.user_currencies.create(amount: 0, currency_type: currency_type)
            currency = user.user_currencies.find_by(user_id: user_id, currency_type: currency_type)
        end
        if amount.to_d == 0
            raise CustomException::InvalidTransferAmount
        end
        currency.amount = currency.amount - amount.to_d
        currency.save

    end

    def add_money(user, currency_type, amount)
        currency =  nil
        currency = user.user_currencies.find_by(currency_type: currency_type)
        if currency.nil?
            user.user_currencies.create(amount: 0, currency_type: currency_type)
            currency = user.user_currencies.find_by(currency_type: currency_type)
        end
        if amount.to_d == 0
            raise CustomException::InvalidTransferAmount
        end
        currency.amount = currency.amount + amount.to_d
        currency.save
    end

    def check_sufficient_balance_to_transfer(user, currency_type, amount)
        currency = nil
        currency = user.user_currencies.find_by(currency_type: currency_type)
        if currency.nil?
            user.user_currencies.create(amount: 0, currency_type: currency_type)
            currency = user.user_currencies.find_by(user_id: user_id, currency_type: currency_type)
        end 
        if currency.amount < amount.to_f
            raise CustomException::NotSufficientFundsToTransfer
        end
    end

    def create_user(params)
        user = nil
        ActiveRecord::Base.transaction do
            user = User.create(full_name: params[:full_name], phone_number: params[:phone_number], password:params[:password], email:params[:email])
            if !user.valid?
                return user
            end
            user.user_currencies.create(amount: 0, currency_type: 0)
            user.user_currencies.create(amount: 0, currency_type: 1)
            user.user_currencies.create(amount: 0, currency_type: 2)
            user.user_currencies.create(amount: 0, currency_type: 3)
            user.user_currencies.create(amount: 0, currency_type: 4)
        end
        return user
    end
end
