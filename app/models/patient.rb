class Patient < ApplicationRecord
  belongs_to :user
  belongs_to :clinic
  has_one_attached :profile

  has_many :health_records, dependent: :destroy
  has_many :heath_conditions, through: :health_records
  has_many :patient_diagnoses, dependent: :destroy

  validates :first_name, :phone_number, presence: true
  validates :phone_number, length: { minimum: 9, maximum: 15 }
  validates :first_name, length: { minimum: 1 }
  validates :phone_number, format: { with: /\A[0-9]+\z/ }
  validate :profile_validation

  before_validation :create_patient_user, if: -> { user_id.nil? }

  enum :gender, {
    male: 0,
    female: 1
  }

  enum :status, {
    active: 0,
    inactive: 1
  }
  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def profile_validation
    return unless profile.attached?
    return if profile.content_type.in?(%w[image/jpeg image/png])

    errors.add(:profile, 'must be a JPEG or PNG')
  end

  def create_patient_user
    return if user.present?

    user = User.create!(
      email: "#{SecureRandom.hex(16)}@doctor.com",
      password: SecureRandom.hex(32).to_s
    )

    update(user_id: user.id)
  end
end
