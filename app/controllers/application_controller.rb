class ApplicationController < ActionController::Base
    #skip_before_action :verify_authenticity_token
    #skip_before_action :authenticate_admin!
    
    protect_from_forgery with: :null_session
    before_action :authorized
    rescue_from ActiveRecord::RecordNotFound, with: :error_message
    rescue_from ActiveRecord::RecordInvalid , with: :error_message
    rescue_from CustomException::NotSufficientFundsToTransfer, with: :error_message
    rescue_from CustomException::RequiredParametersAreMissing, with: :error_message
    rescue_from CustomException::InvalidTransferAmount, with: :error_message
    rescue_from ActiveRecord::StatementInvalid, with: :error_message
    rescue_from ActiveRecord::StaleObjectError, with: :error_message
    rescue_from ArgumentError, with: :error_message


    def encode_token(payload)
      JWT.encode(payload, 's3cr3t') # header boidy hash 
    end
  
    def auth_header
      # { Authorization: 'Bearer <token>' }
      request.headers['Authorization']
    end
    
    def decoded_token
      if auth_header
        #token = auth_header.split(' ')[1]
        token = auth_header
        # header: { 'Authorization': 'Bearer <token>' }
        begin
          JWT.decode(token, 's3cr3t', true, algorithm: 'HS256') #
        rescue JWT::DecodeError
          nil
        end
      end
    end
  
    def logged_in_user
      if decoded_token
        p decoded_token
        user_id = decoded_token[0]['user_id']
        @user = User.find_by(id: user_id)
        p @user
      end
    end
  
    def logged_in?
      logged_in_user
    end
  
    def authorized
      p @user
      render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    end




    private

    def error_message(error)
      render json: {message: error}, status: :unprocessable_entity
    end


end
