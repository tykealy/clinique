class Service < ApplicationRecord
  belongs_to :clinic

  enum :status, { active: 1, inactive: 0 }
  enum :price_type, { fixed: 0, range: 1 }

  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :price_max, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validate :validate_price_range, if: -> { range? && price.present? && price_max.present? }

  private

  def validate_price_range
    return unless price_max <= price

    errors.add(:price_max, 'must be greater than minimum price')
  end
end
