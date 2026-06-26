class PostPolicy < ApplicationPolicy
  def index? = true
  def show? = true

  def create?
    has_permission?(action: "WRITE", resource: "POSTS") || user&.has_role?("admin")
  end

  def update?
    has_permission?(action: "WRITE", resource: "POSTS") || user&.has_role?("admin") || record.author == user
  end

  def destroy?
    has_permission?(action: "DELETE", resource: "POSTS") || user&.has_role?("admin")
  end

  def publish?
    has_permission?(action: "PUBLISH", resource: "POSTS") || user&.has_role?("editor") || user&.has_role?("admin")
  end
end
