require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:isbn) }
    it { should validate_uniqueness_of(:isbn) }
    it { should validate_presence_of(:total_copies) }
    it { should validate_numericality_of(:total_copies).only_integer.is_greater_than(0) }
  end

  describe 'associations' do
    it { should have_many(:borrowings) }
  end

  describe '.search' do
    let!(:book1) { create(:book, title: 'Ruby Programming', author: 'John Doe', isbn: '1234567890') }
    let!(:book2) { create(:book, title: 'JavaScript Essentials', author: 'Jane Smith', isbn: '0987654321') }
    let!(:book3) { create(:book, title: 'Advanced Ruby', author: 'John Doe', isbn: '1122334455') }

    it 'returns all books when no parameters are provided' do
      expect(Book.search({})).to match_array([book1, book2, book3])
    end

    it 'returns books matching the title' do
      expect(Book.search({ title: 'Ruby' })).to match_array([book1, book3])
    end

    it 'returns books matching the author' do
      expect(Book.search({ author: 'John Doe' })).to match_array([book1, book3])
    end

    it 'returns books matching the isbn' do
      expect(Book.search({ isbn: '1234567890' })).to match_array([book1])
    end

    it 'returns books matching multiple parameters' do
      expect(Book.search({ title: 'Ruby', author: 'John Doe' })).to match_array([book1, book3])
    end

    it 'returns no books if no matches are found' do
      expect(Book.search({ title: 'Nonexistent' })).to be_empty
    end

    it 'is case insensitive' do
      expect(Book.search({ title: 'ruby programming' })).to match_array([book1])
    end

    it 'ignores blank parameters' do
      expect(Book.search({ title: '', author: 'John Doe' })).to match_array([book1, book3])
    end
  end

  describe '.total_borrowed' do
    let!(:book) { create(:book) }
    let!(:user) { create(:user) }
    let!(:borrowed_books) { create_list(:borrowing, 3, user: user, book: book, returned_on: nil) }
    let!(:returned_books) { create_list(:borrowing, 2, user: user, book: book, returned_on: Date.yesterday) }

    it 'returns the total number of borrowed books' do
      expect(Book.total_borrowed).to eq(3)
    end

    it 'returns zero when no books are borrowed' do
      Borrowing.update_all(returned_on: Date.yesterday)
      expect(Book.total_borrowed).to eq(0)
    end
  end
end