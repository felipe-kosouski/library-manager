class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :borrowings

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  enum role: { member: 0, librarian: 1 }

  def has_borrow_for_book?(book)
    borrowings.exists?(book: book, returned_on: nil)
  end

  def borrowed_books
    borrowings.includes(:book).where(returned_on: nil)
  end

  def overdue_books
    borrowings.includes(:book).where('due_on < ? AND returned_on IS NULL', Date.today)
  end
end
