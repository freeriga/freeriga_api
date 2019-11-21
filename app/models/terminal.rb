# frozen_string_literal: true

class Terminal < ActiveRecord::Base
  rolify role_cname: 'TerminalRole'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable
  include DeviseTokenAuth::Concerns::User
  attr_accessor :login
  belongs_to :location
  validates :location, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true


  def login
    @login || self.name || self.email
  end

  def login=(login)
    @login = self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:name) || conditions.has_key?(:email)
      where(conditions.to_hash).first
    end
  end

end
