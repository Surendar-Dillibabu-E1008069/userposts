class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation
  has_many :posts
  has_many :followers

  validates :first_name,
            :presence => { :message => "First name is mandatory" }
  validates :last_name,
            :presence => { :message => "Last name is mandatory" }
  validates :email,
            :presence => { :message => "Email is mandatory" },
            :uniqueness => { :message => "Given email already present in our system. Please try with different email" },
            :format => { :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, :message => "Please provide valid email" }
  validates :password,
            :presence => { :message => "Password is mandatory" },
            :length => { :minimum => 6, :maximum => 20, :message => "Password should contain minimum 6 character and maximum 20 characters" },
            :confirmation => { :message => "Password and confirmation password doesn't match" }
  validates :password_confirmation,
            :presence => { :message => "Confirmation password is mandatory" }
end
