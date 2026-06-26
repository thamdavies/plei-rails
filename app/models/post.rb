class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :category
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  enum :status, { draft: 0, published: 1, archived: 2 }

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  def to_param
    slug
  end

  scope :published, -> { where(status: :published) }
  scope :by_category, ->(slug) { joins(:category).where(categories: { slug: }) }
  scope :by_tag, ->(slug) { joins(:tags).where(tags: { slug: }) }
end
