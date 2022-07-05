class User < ApplicationRecord
    has_secure_password
    has_many :user_transactions
    has_many :user_currencies
    #validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 
    #validates :email, format: {with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i}
    #validates_format_of  :email, :with => /[^\s]@[^\s]/
    #validates :email, email_format: { message: 'Invalid email format' }
    #validates :email, format: { with: /^(.+)@(.+)$/, message: "Email invalid" },presence:true, uniqueness: { case_sensitive: false }, length: { minimum: 4, maximum: 254 }

    validates :full_name, presence: {message: "Name can't be left blank!!"} 
    validates :phone_number, presence: true, length: {is: 10}, uniqueness: {:message => "Phone Number already exists."}
    validates :password, presence: {:message => "Password can't be left blank."}

    mount_uploader:avatar, AvatarUploader
end
