class Doctor < ApplicationRecord
  belongs_to :clinic
  belongs_to :user

  store_accessor :preferences, :bg_color, :font_color

  has_many :appointments
  has_one_attached :profile
  validates :first_name, :phone_number, presence: true
  validates :phone_number, length: { minimum: 9, maximum: 15 }
  validates :first_name, length: { minimum: 1 }
  validates :phone_number, format: { with: /\A[0-9]+\z/ }
  validate :profile_validation

  before_validation :create_doctor_user, if: -> { user_id.nil? }

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def profile_validation
    return unless profile.attached?
    return if profile.content_type.in?(%w[image/jpeg image/png])

    errors.add(:profile, 'must be a JPEG or PNG')
  end

  def create_doctor_user
    return if user.present?

    user = User.create!(
      email: "#{SecureRandom.hex(16)}@doctor.com",
      password: SecureRandom.hex(32).to_s
    )

    update(user_id: user.id)
  end
end
