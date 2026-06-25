class User < ApplicationRecord
  include Clearance::User

  has_many :posts, foreign_key: :author_id, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, uniqueness: { case_sensitive: false }

  def has_permission?(action:, resource:)
    roles.joins(:role_permissions)
         .joins(:permissions)
         .where(permissions: { action:, resource: })
         .exists?
  end

  def has_role?(role_name)
    roles.exists?(name: role_name)
  end
end
