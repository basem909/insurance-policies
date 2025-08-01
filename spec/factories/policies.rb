FactoryBot.define do
  factory :policy do
    user            { create(:user, :client) }
    start_date      { Date.today }
    end_date        { 1.year.from_now.to_date }
    status          { :active }
  end
end
