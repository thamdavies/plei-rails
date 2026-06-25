# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# --- Vietnamese provinces (existing) ---
VN_UNITS_SQL_PATH = Rails.root.join("db/seeds/vn_units.sql")

unless AdministrativeRegion.any?
  puts "Seeding Vietnamese provinces..."
  sql = File.read(VN_UNITS_SQL_PATH)
  ActiveRecord::Base.connection.execute(sql)
  puts "  #{AdministrativeRegion.count} regions, #{AdministrativeUnit.count} units, #{Province.count} provinces, #{Ward.count} wards"
end

# --- Roles & Permissions (RBAC) ---
puts "Seeding roles & permissions..."

admin_role = Role.find_or_create_by!(name: "admin") do |r|
  r.description = "Full system access"
end

editor_role = Role.find_or_create_by!(name: "editor") do |r|
  r.description = "Can manage and publish posts"
end

author_role = Role.find_or_create_by!(name: "author") do |r|
  r.description = "Can create and edit own posts"
end

permissions_data = [
  { action: "READ", resource: "POSTS", slug: "posts:read" },
  { action: "WRITE", resource: "POSTS", slug: "posts:write" },
  { action: "DELETE", resource: "POSTS", slug: "posts:delete" },
  { action: "PUBLISH", resource: "POSTS", slug: "posts:publish" },
  { action: "MANAGE", resource: "CATEGORIES", slug: "categories:manage" },
  { action: "MANAGE", resource: "USERS", slug: "users:manage" },
]

permissions = permissions_data.map do |data|
  Permission.find_or_create_by!(slug: data[:slug]) do |p|
    p.action = data[:action]
    p.resource = data[:resource]
  end
end

read_posts = permissions.find { |p| p.slug == "posts:read" }
write_posts = permissions.find { |p| p.slug == "posts:write" }
delete_posts = permissions.find { |p| p.slug == "posts:delete" }
publish_posts = permissions.find { |p| p.slug == "posts:publish" }
manage_categories = permissions.find { |p| p.slug == "categories:manage" }
manage_users = permissions.find { |p| p.slug == "users:manage" }

# Admin gets all permissions
[read_posts, write_posts, delete_posts, publish_posts, manage_categories, manage_users].each do |perm|
  RolePermission.find_or_create_by!(role: admin_role, permission: perm)
end

# Editor gets read, write, publish
[read_posts, write_posts, publish_posts].each do |perm|
  RolePermission.find_or_create_by!(role: editor_role, permission: perm)
end

# Author gets read, write
[read_posts, write_posts].each do |perm|
  RolePermission.find_or_create_by!(role: author_role, permission: perm)
end

# --- Admin user ---
puts "Seeding admin user..."
admin_user = User.find_or_create_by!(email: "admin@plei.dev") do |u|
  u.username = "admin"
  u.password = "password123"
end
UserRole.find_or_create_by!(user: admin_user, role: admin_role)

# --- Categories ---
puts "Seeding categories..."
categories_data = [
  { name: "CRUD", slug: "crud", description: "Create, read, update, and delete patterns" },
  { name: "UI", slug: "ui", description: "User interface components and interactions" },
  { name: "Auth", slug: "auth", description: "Authentication and authorization" },
  { name: "API", slug: "api", description: "API development and integration" },
]

categories = categories_data.map do |data|
  Category.find_or_create_by!(slug: data[:slug]) do |c|
    c.name = data[:name]
    c.description = data[:description]
  end
end

crud_cat = categories.find { |c| c.slug == "crud" }
ui_cat = categories.find { |c| c.slug == "ui" }
auth_cat = categories.find { |c| c.slug == "auth" }
api_cat = categories.find { |c| c.slug == "api" }

# --- Tags ---
puts "Seeding tags..."
tags_data = %w[
  modal form turbo stimulus search autocomplete authentication session password
  upload image storage pagination infinite-scroll api rest notification toast
].map do |name|
  Tag.find_or_create_by!(slug: name) { |t| t.name = name }
end

tag_map = tags_data.index_by(&:slug)

# --- Posts (from existing EXAMPLES) ---
puts "Seeding posts..."
posts_data = [
  {
    title: "CRUD with Modal",
    slug: "crud-with-modal",
    description: "Create, read, update, and delete records using a modal dialog pattern with Turbo Frames and Stimulus.",
    summary: "Build a complete CRUD interface with modal dialogs using Hotwire.",
    category: crud_cat,
    tags: %w[modal form turbo],
  },
  {
    title: "Search with Autocomplete",
    slug: "search-with-autocomplete",
    description: "Real-time search with autocomplete suggestions using Stimulus controllers and debounced fetch requests.",
    summary: "Implement a search box with live autocomplete results.",
    category: ui_cat,
    tags: %w[search autocomplete stimulus],
  },
  {
    title: "User Authentication",
    slug: "user-authentication",
    description: "Complete authentication flow with login, registration, password reset, and session management.",
    summary: "Build a full authentication system from scratch.",
    category: auth_cat,
    tags: %w[authentication session password],
  },
  {
    title: "Image Upload with Preview",
    slug: "image-upload-with-preview",
    description: "Drag-and-drop image upload with live preview, progress bar, and Active Storage integration.",
    summary: "Accept image uploads with drag-and-drop and real-time preview.",
    category: crud_cat,
    tags: %w[upload image storage],
  },
  {
    title: "Pagination & Infinite Scroll",
    slug: "pagination-infinite-scroll",
    description: "Paginate large result sets with classic page numbers and seamless infinite scroll using Hotwire.",
    summary: "Add pagination and infinite scrolling to any list view.",
    category: ui_cat,
    tags: %w[pagination infinite-scroll stimulus],
  },
  {
    title: "API Token Authentication",
    slug: "api-token-authentication",
    description: "Secure your API with token-based authentication, rate limiting, and request validation.",
    summary: "Protect your Rails API with token-based auth.",
    category: api_cat,
    tags: %w[api rest authentication],
  },
  {
    title: "Inline Editing",
    slug: "inline-editing",
    description: "Click-to-edit any field on the page with automatic save using Turbo Frames and optimistic UI updates.",
    summary: "Make any field editable inline with automatic saving.",
    category: crud_cat,
    tags: %w[form stimulus turbo],
  },
  {
    title: "Notification Toast System",
    slug: "notification-toast-system",
    description: "Display real-time toast notifications with auto-dismiss, stacking, and action callbacks.",
    summary: "Build a toast notification system for user feedback.",
    category: ui_cat,
    tags: %w[notification toast stimulus],
  },
]

posts_data.each do |data|
  post = Post.find_or_create_by!(slug: data[:slug]) do |p|
    p.title = data[:title]
    p.summary = data[:summary]
    p.description = data[:description]
    p.body = "TODO: Add full example content for #{data[:title]}"
    p.status = :published
    p.author = admin_user
    p.category = data[:category]
  end

  data[:tags].each do |tag_slug|
    tag = tag_map[tag_slug]
    PostTag.find_or_create_by!(post:, tag:) if tag
  end
end

puts "Seeding complete!"
puts "  #{User.count} users"
puts "  #{Role.count} roles"
puts "  #{Permission.count} permissions"
puts "  #{Category.count} categories"
puts "  #{Tag.count} tags"
puts "  #{Post.count} posts"
