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
end