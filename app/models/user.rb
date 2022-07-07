class User < ApplicationRecord
    extend ActiveModel::Callbacks
    include ActiveModel::Validations
    include ActiveModel::OneTimePassword
    has_secure_password
    has_one_time_password
    has_many :user_transactions
    has_many :user_currencies
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 
    validates :password, presence: {:message => "Password can't be left blank."}, on: :create

    validates :full_name, presence: {message: "Name can't be left blank!!"} 
    validates :phone_number, presence: true, length: {is: 10}, uniqueness: {:message => "Phone Number already exists."}
    

    mount_uploader:avatar, AvatarUploader
end
