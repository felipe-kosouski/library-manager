class Book < ApplicationRecord
  has_many :borrowings, dependent: :destroy
  validates :title, presence: true
  validates :author, presence: true
  validates :isbn, presence: true, uniqueness: true
  validates :total_copies, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def self.search(params)
    books = Book.all
    params.each do |key, value|
      next if value.blank?
      books = books.where("lower(#{key}) LIKE ?", "%#{value.downcase}%")
    end
    books
  end

  def self.total_count
    count
  end

  def self.total_borrowed
    joins(:borrowings).where(borrowings: { returned_on: nil }).count
  end

  def available_copies
    total_copies - borrowings.count
  end

  def is_available?
    available_copies > 0
  end

end
