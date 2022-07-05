class UsersController < ApplicationController
  #before_action :set_user, only: [:show, :update, :destroy]
  #skip_before_action :verify_authenticity_token
  before_action :authorized, only: [:auto_login]


  def initialize
    @two_fa = TwoFAuthentication.new
  end

  def create
    @user = UserService.new.create_user(params)
    if @user.valid?
      @two_fa.register_user(@user)
      #token = encode_token({user_id: @user.id})
      render json: {message: "Successfully created the user"}
    else
      render json: {error: @user.errors}
    end
  end

  def show_image
    user = UserService.new.get_user(params[:user_id])
    if !user.avatar.present?
      return render json: "Invalid request",status: :unprocessable_entity
    end
    image = open(user.avatar.current_path)
    send_data image.read, type: 'image/png', disposition: 'inline'
  end

  def upload_image
    UserService.new.upload_image(params)
    render json: "Successfully uploaded image"
  end

#register 2Fa for user
  # def create_two_fa
  #   user = User.find(params[:user_id])
  #   @two_fa.register_user(user)
  # end

  # def send_otp_two_fa
  #   user = User.find(params[:user_id])
  #   response = @two_fa.send_otp(user.authy_id)
  #   render json: response
  # end

  def verify_two_fa
    user = User.find(params[:user_id])
    is_verified = @two_fa.verify_token(user.authy_id, params[:token])
    return is_verified
  end
  
  # LOGGING IN
  def login
    @user = User.find_by(id: params[:user_id])
     if @user && @user.authenticate(params[:password]) && self.verify_two_fa
      token = encode_token({user_id: @user.id})
      render json: {message: "Verifired", token: token}
    else
      render json: {error: "Invalid user id or password or 2FA"}
    end
  end


  # def auto_login
  #   render json: @user
  # end 

  # GET /users/1
  # def show
  #   p @@token
  #   @users = User.all
  #   render json: @users
  # end


  # PATCH/PUT /users/1
  # def update
  #   if @user.update(user_params)
  #     render json: @user
  #   else
  #     render json: @user.errors, status: :unprocessable_entity
  #   end
  # end

  # def logout
  #   @@token = nil
  #   render json: "User logout"

  # end

  # DELETE /users/1
  # def destroy
  #   @user.destroy
  # end

  private
  def user_params
    params.permit(:full_name, :password)
  end
end
