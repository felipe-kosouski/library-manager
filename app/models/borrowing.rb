class Borrowing < ApplicationRecord
  belongs_to :user, optional: false
  belongs_to :book, optional: false

  validates :borrowed_on, presence: true
  validates :due_on, presence: true

  def self.due_today
    where(due_on: Date.current, returned_on: nil)
  end

  def self.overdue
    where('due_on < ? AND returned_on IS NULL', Date.current)
  end

  def is_due?
    due_on < Date.current
  end

  def is_overdue?
    returned_on.nil? && is_due?
  end

  def returned_on_time?
    returned_on <= due_on
  end
end
