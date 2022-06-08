# frozen_string_literal: true

class User < ActiveRecord::Base
  include LiberalEnum
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  self.primary_key = 'uid'
  enum role: { user: 0, admin: 1 }
  liberal_enum :role

  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: ["0","1"] }
  validates_numericality_of :role, on: :create, message: "is not a number"
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true, if: lambda {| u| u.password.present? }
end
