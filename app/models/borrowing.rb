class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :borrowed_on, presence: true
  validates :due_on, presence: true

  def self.due_today
    where(due_on: Time.zone.today, returned_on: nil)
  end

  def self.overdue
    where('due_on < ? AND returned_on IS NULL', Time.zone.today)
  end

  def is_due?
    due_on < Time.zone.today
  end

  def is_overdue?
    returned_on.nil? && is_due?
  end

  def returned_on_time?
    returned_on <= due_on
  end
end
