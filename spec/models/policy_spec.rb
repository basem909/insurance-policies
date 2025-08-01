require "rails_helper"

RSpec.describe Policy, type: :model do
  subject(:policy) { build(:policy) }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:start_date) }
  it { is_expected.to validate_presence_of(:end_date) }
  it { is_expected.to validate_presence_of(:status) }

  # We no longer use validate_presence_of/validate_uniqueness_of for policy_number
  # since it's generated via callback. We'll test its behavior directly.

  describe "policy_number generation & validation" do
    it "auto-generates a 12-digit policy_number on create" do
      new_policy = build(:policy)
      expect(new_policy.policy_number).to be_nil

      new_policy.save!
      expect(new_policy.policy_number).to match(/\A\d{12}\z/)
    end

    it "does not allow manually set invalid formats" do
      policy.policy_number = "123"
      expect(policy).not_to be_valid
      expect(policy.errors[:policy_number]).to include("must be 12 digits")
    end

    it "does not allow duplicates when manually set" do
      existing = create(:policy)
      dup      = build(:policy,
                       start_date: existing.start_date,
                       end_date: existing.end_date,
                       status: existing.status)
      dup.policy_number = existing.policy_number

      expect(dup).not_to be_valid
      expect(dup.errors[:policy_number]).to include("has already been taken")
    end
  end

  it "validates end_date is after start_date" do
    policy.start_date = Date.today
    policy.end_date   = 1.day.ago

    expect(policy).not_to be_valid
    expect(policy.errors[:end_date]).to include("must be after the start date")
  end

  describe "statuses enum" do
    it "defines the expected string-backed statuses" do
      expect(Policy.statuses.keys).to contain_exactly(
        "active", "pending", "expired", "canceled"
      )
    end
  end
end
