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

  def examples
@posts = Post.published.includes(:author, :category, :tags)
@categories = Category.all.order(:name)
@tags = Tag.all.order(:name)
    @selected_category = params[:category]
    @selected_tag = params[:tag]

    @posts = @posts.by_category(@selected_category) if @selected_category.present?
    @posts = @posts.by_tag(@selected_tag) if @selected_tag.present?

    render Views::Pages::Examples.new(
      posts: @posts,
      categories: @categories,
      tags: @tags,
      selected_category: @selected_category,
      selected_tag: @selected_tag
    )
  end

  def show
    @post = Post.published.includes(:category, :tags).find_by!(slug: params[:id])
    render Views::Pages::Show.new(post: @post)
  end
end
