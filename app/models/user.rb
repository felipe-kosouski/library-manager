class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :borrowings

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  enum role: { member: 0, librarian: 1 }
end
