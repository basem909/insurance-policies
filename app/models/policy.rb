class Policy < ApplicationRecord
  belongs_to :user

  # Generate a unique 12-digit policy number before creation
  before_validation :generate_policy_number

  # Status enum
  enum status: {
    active:   "active",
    pending:  "pending",
    expired:  "expired",
    canceled: "canceled"
  }

  validates :policy_number,
            presence: true,
            uniqueness: true,
            format: { with: /\A\d{12}\z/, message: "must be 12 digits" }

  validates :start_date, :end_date, :status, presence: true
  validate  :end_date_after_start

  private

  def generate_policy_number
    return if policy_number.present?
    self.policy_number = rand(10**12).to_s.rjust(12, "0")
  end

  def end_date_after_start
    return if end_date.blank? || start_date.blank?
    errors.add(:end_date, "must be after the start date") if end_date < start_date
  end
end
