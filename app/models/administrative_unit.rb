class AdministrativeUnit < ApplicationRecord
  self.primary_key = :id

  has_many :provinces, foreign_key: :administrative_unit_id, inverse_of: :administrative_unit
  has_many :wards, foreign_key: :administrative_unit_id, inverse_of: :administrative_unit

  validates :code_name, uniqueness: { allow_nil: true }
end
