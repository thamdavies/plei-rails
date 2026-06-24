class Ward < ApplicationRecord
  self.primary_key = :code

  belongs_to :province, foreign_key: :province_code, primary_key: :code, inverse_of: :wards
  belongs_to :administrative_unit

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  scope :urban, -> {
    joins(:administrative_unit).where(administrative_units: { code_name: "phuong" })
  }
  scope :rural, -> {
    joins(:administrative_unit).where(administrative_units: { code_name: "xa" })
  }
  scope :special, -> {
    joins(:administrative_unit).where(administrative_units: { code_name: "dac_khu" })
  }
end
