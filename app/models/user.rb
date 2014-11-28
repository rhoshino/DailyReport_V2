class User < ActiveRecord::Base

  has_many :reports, dependent: :destroy

  validates :name,presence: true,
                  length: {maximum: 50}

  before_save { self.email = email.downcase }


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


end
