# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
         # :omniauthable, :omniauth_providers => [:facebook]
  include DeviseTokenAuth::Concerns::User
  belongs_to :location
  has_many :tasks
  has_many :comments
  has_one_attached :avatar

  def headers_for(action)
  {:from => 'Free Riga <terminal@freeriga.lv>'}
  end
end
