class Clinic < ApplicationRecord
  has_one_attached :logo
  has_many :services, dependent: :destroy
  has_many :clinic_users, dependent: :destroy
  has_many :users, through: :clinic_users

  enum :status, { active: 0, inactive: 1 }

  validate :logo_validation
  def logo_validation
    return unless logo.attached?
    return if logo.content_type.in?(%w[image/jpeg image/png])

    errors.add(:logo, 'must be a JPEG or PNG')
  end
end
