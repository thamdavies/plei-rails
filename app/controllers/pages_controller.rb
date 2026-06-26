class PagesController < ApplicationController
  def home
    published_counts = Category
      .left_joins(:posts)
      .merge(Post.published)
      .group("categories.id")
      .count

    render Views::Pages::Home.new(
      featured_examples: Post.published.includes(:author, :category, :tags).limit(3),
      categories: Category.all.order(:name),
      published_counts: published_counts
    )
  end
end
