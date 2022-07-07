class UserService
    
    def encode_token(payload)
        JWT.encode(payload, 's3cr3t') 
    end
    
    def auth_header request
        request.headers['Authorization']
    end
      
    def decoded_token request
        token = auth_header request
        if token
            begin
                return JWT.decode(token, 's3cr3t', true, algorithm: 'HS256') 
            rescue JWT::DecodeError
                nil
            end
        end
    end
    
    def logged_in_user request
        d_token = decoded_token request
        if d_token
            d_token[0]['user_id']
        end
    end
    
    def logged_in? request
        logged_in_user request
    end

    def upload_image(user,params)
        user.update!(avatar:params[:image])
    end


    def create_user(params)
        user = nil
        ActiveRecord::Base.transaction do
            user = User.create!(full_name: params[:full_name], phone_number: params[:phone_number], password:params[:password], email:params[:email])
            for currency_type in 0..4 do
                user.user_currencies.create(amount: 0, currency_type: currency_type)
            end
        end
        return user
    end
end
