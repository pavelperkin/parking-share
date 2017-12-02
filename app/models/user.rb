class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_format_of :email, with: Devise.email_regexp, message: 'Please enter a valid email'
  validates_format_of :email, with: /[a-zA-Z]+@lohika.com\z/, message: 'Email should be with lohika.com domain'
end
