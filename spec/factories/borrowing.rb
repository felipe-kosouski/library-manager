FactoryBot.define do
  factory :borrowing do
    user
    book
    borrowed_on { Time.zone.today }
    due_on { 2.weeks.from_now }
  end
end