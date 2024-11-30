class Clinic < ApplicationRecord
  belongs_to :user
  has_one_attached :logo

  enum :status, { active: 0, inactive: 1 }

  validate :logo_validation
  def logo_validation
    return unless logo.attached?
    return if logo.content_type.in?(%w[image/jpeg image/png])

    errors.add(:logo, 'must be a JPEG or PNG')
  end
end
