class ExamplesController < ApplicationController
  def index
    @posts = Post.published.includes(:author, :category, :tags)
    @categories = Category.all.order(:name)
    @tags = Tag.all.order(:name)
    @selected_category = params[:category]
    @selected_tag = params[:tag]

    @posts = @posts.by_category(@selected_category) if @selected_category.present?
    @posts = @posts.by_tag(@selected_tag) if @selected_tag.present?

    # render Views::Examples::Index.new(
    #   posts: @posts,
    #   categories: @categories,
    #   tags: @tags,
    #   selected_category: @selected_category,
    #   selected_tag: @selected_tag
    # )
  end

  def show
    run(User::Operations::Create::Present) do |result|
      @user_form = result[:"contract.default"]
    end

    run(User::Operations::Index) do |result|
      @pagy, users = pagy(result[:users], limit: Settings.pagination.default_per_page)
      @users = users.decorate
    end

    @post = Post.published.includes(:author, :category, :tags).find_by!(slug: params[:id])

    render Views::Examples::Show.new(
      post: @post,
      user_form: @user_form,
      pagy: @pagy,
      users: @users
    )
  end
end
