class HealthCondition < ApplicationRecord
  has_many :health_records, dependent: :destroy
  has_many :patients, through: :health_records
end
