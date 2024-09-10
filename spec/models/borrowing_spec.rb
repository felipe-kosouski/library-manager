require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:borrowed_on) }
    it { should validate_presence_of(:due_on) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:book) }
  end

  describe '.due_today' do
    let!(:due_today_borrowings) { create_list(:borrowing, 3, due_on: Date.current, returned_on: nil) }
    let!(:not_due_today_borrowings) { create_list(:borrowing, 2, due_on: Date.current + 1.day, returned_on: nil) }
    let!(:returned_borrowings) { create_list(:borrowing, 2, due_on: Date.current, returned_on: Date.current + 2.weeks) }

    it 'returns borrowings due today' do
      expect(Borrowing.due_today).to match_array(due_today_borrowings)
    end

    it 'does not return borrowings not due today' do
      expect(Borrowing.due_today).not_to include(*not_due_today_borrowings)
    end

    it 'does not return borrowings that have been returned' do
      expect(Borrowing.due_today).not_to include(*returned_borrowings)
    end
  end

  describe '.overdue' do
    let!(:overdue_borrowings) { create_list(:borrowing, 3, due_on: Date.current - 1.day, returned_on: nil) }
    let!(:not_overdue_borrowings) { create_list(:borrowing, 2, due_on: Date.current + 1.day, returned_on: nil) }
    let!(:returned_borrowings) { create_list(:borrowing, 2, due_on: Date.current - 1.day, returned_on: Date.current + 2.weeks) }

    it 'returns borrowings that are overdue' do
      expect(Borrowing.overdue).to match_array(overdue_borrowings)
    end

    it 'does not return borrowings that are not overdue' do
      expect(Borrowing.overdue).not_to include(*not_overdue_borrowings)
    end

    it 'does not return borrowings that have been returned' do
      expect(Borrowing.overdue).not_to include(*returned_borrowings)
    end
  end
end