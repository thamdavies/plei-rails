class PagesController < ApplicationController
  def home
    render Views::Pages::Home.new(
      featured_examples: Post.published.includes(:category, :tags).limit(3),
      categories: Category.all.order(:name)
    )
  end

  def examples
    @posts = Post.published.includes(:category, :tags)
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
