require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'associations' do
    it { should have_many(:borrowings) }
  end

  describe '#has_borrow_for_book?' do
    let(:user) { create(:user) }
    let(:book) { create(:book) }
    let(:other_book) { create(:book) }

    it 'returns true if the user has borrowed the book and not returned it' do
      create(:borrowing, user: user, book: book, returned_on: nil)
      expect(user.has_borrow_for_book?(book)).to be true
    end

    it 'returns false if the user has borrowed the book and returned it' do
      create(:borrowing, user: user, book: book, returned_on: Date.yesterday)
      expect(user.has_borrow_for_book?(book)).to be false
    end

    it 'returns false if the user has not borrowed the book' do
      expect(user.has_borrow_for_book?(book)).to be false
    end

    it 'returns false if the user has borrowed a different book' do
      create(:borrowing, user: user, book: other_book, returned_on: nil)
      expect(user.has_borrow_for_book?(book)).to be false
    end
  end

  describe '#borrowed_books' do
    let(:user) { create(:user) }
    let(:book1) { create(:book) }
    let(:book2) { create(:book) }
    let(:book3) { create(:book) }

    it 'returns books that are currently borrowed and not returned' do
      borrowing1 = create(:borrowing, user: user, book: book1, returned_on: nil)
      borrowing2 = create(:borrowing, user: user, book: book2, returned_on: nil)
      expect(user.borrowed_books).to match_array([borrowing1, borrowing2])
    end

    it 'does not return books that have been returned' do
      create(:borrowing, user: user, book: book1, returned_on: Date.yesterday)
      expect(user.borrowed_books).to be_empty
    end

    it 'does not return books borrowed by other users' do
      other_user = create(:user)
      create(:borrowing, user: other_user, book: book3, returned_on: nil)
      expect(user.borrowed_books).to be_empty
    end
  end

  describe '#overdue_books' do
    let(:user) { create(:user) }
    let(:book1) { create(:book) }
    let(:book2) { create(:book) }
    let(:book3) { create(:book) }

    it 'returns books that are overdue and not returned' do
      overdue_borrowing1 = create(:borrowing, user: user, book: book1, due_on: Date.yesterday, returned_on: nil)
      overdue_borrowing2 = create(:borrowing, user: user, book: book2, due_on: Date.yesterday, returned_on: nil)
      expect(user.overdue_books).to match_array([overdue_borrowing1, overdue_borrowing2])
    end

    it 'does not return books that are not overdue' do
      create(:borrowing, user: user, book: book1, due_on: Date.tomorrow, returned_on: nil)
      expect(user.overdue_books).to be_empty
    end

    it 'does not return books that have been returned' do
      create(:borrowing, user: user, book: book1, due_on: Date.yesterday, returned_on: Date.yesterday)
      expect(user.overdue_books).to be_empty
    end

    it 'does not return books borrowed by other users' do
      other_user = create(:user)
      create(:borrowing, user: other_user, book: book3, due_on: Date.yesterday, returned_on: nil)
      expect(user.overdue_books).to be_empty
    end
  end
end