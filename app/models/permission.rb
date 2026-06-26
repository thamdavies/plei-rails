class Permission < ApplicationRecord
  has_many :role_permissions, dependent: :destroy
  has_many :roles, through: :role_permissions

  validates :action, presence: true
  validates :resource, presence: true
  validates :slug, presence: true, uniqueness: true
end
