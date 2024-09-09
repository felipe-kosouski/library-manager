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
end