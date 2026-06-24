class AdministrativeRegion < ApplicationRecord
  self.primary_key = :id

  validates :name, presence: true
  validates :name_en, presence: true
  validates :code_name, uniqueness: { allow_nil: true }
end
