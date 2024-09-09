class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :borrowed_on, presence: true
  validates :due_on, presence: true
end
