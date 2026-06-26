class ExamplesController < ApplicationController
  def index
    @posts = Post.published.includes(:author, :category, :tags)
    @categories = Category.all.order(:name)
    @tags = Tag.all.order(:name)
    @selected_category = params[:category]
    @selected_tag = params[:tag]

    @posts = @posts.by_category(@selected_category) if @selected_category.present?
    @posts = @posts.by_tag(@selected_tag) if @selected_tag.present?

    render Views::Examples::Index.new(
      posts: @posts,
      categories: @categories,
      tags: @tags,
      selected_category: @selected_category,
      selected_tag: @selected_tag
    )
  end

  def show
    @post = Post.published.includes(:author, :category, :tags).find_by!(slug: params[:id])
    render Views::Examples::Show.new(post: @post)
  end
end
