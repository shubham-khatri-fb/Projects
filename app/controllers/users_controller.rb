class UsersController < ApplicationController

  skip_before_action :authorized, only: [:create, :login]


  def create
    @user = @user_service.create_user(params)
    render json: {message: "Successfully created the user", Two_FA_Key:@user.otp_secret_key}
  end

  def show_image
    if !@current_user.avatar.present?
      raise ActiveRecord::RecordNotFound
    end
    image = open(@current_user.avatar.current_path)
    send_data image.read, type: 'image/png', disposition: 'inline'
  end

  def upload_image
    @user_service.upload_image(@current_user,params)
    render json: "Successfully uploaded image"
  end


  def login
    @user = User.find(params[:user_id])
     if !@user.authenticate(params[:password]) || !@user.authenticate_otp(params[:otp])
      raise CustomException::Validaton.new "Invalid user id or password or 2FA"
     end
    token = @user_service.encode_token({user_id: @user.id})
    render json: {message: "Verifired", token: token}
  end


  private
  def user_params
    params.permit(:full_name, :password)
  end
end
