class Province < ApplicationRecord
  self.primary_key = :code

  belongs_to :administrative_unit
  has_many :wards, foreign_key: :province_code, primary_key: :code, inverse_of: :province

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :full_name, presence: true

  scope :municipalities, -> {
    joins(:administrative_unit).where(administrative_units: { code_name: "thanh_pho_truc_thuoc_trung_uong" })
  }
  scope :provinces_only, -> {
    joins(:administrative_unit).where(administrative_units: { code_name: "tinh" })
  }
end
