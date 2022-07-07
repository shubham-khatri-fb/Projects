class ApplicationController < ActionController::Base
    include Rescue
    protect_from_forgery with: :null_session
    before_action :authorized
    
    attr_accessor :current_user

    def initialize
      @user_service = UserService.new
    end

    private
  
    def authorized
      logged_in_user_id = nil
      logged_in_user_id = UserService.new.logged_in? request
      if !logged_in_user_id.nil?
        @current_user = User.find(logged_in_user_id)
      end
      render json: { message: 'Please log in' }, status: :unauthorized unless logged_in_user_id
    end
    

end
  