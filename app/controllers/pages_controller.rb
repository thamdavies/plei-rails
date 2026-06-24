class PagesController < ApplicationController
  EXAMPLES = [
    {
      title: "CRUD with Modal",
      description: "Create, read, update, and delete records using a modal dialog pattern with Turbo Frames and Stimulus.",
      category: "CRUD",
      tags: %w[modal form turbo],
      cover_tone: "from-indigo-950 via-indigo-900 to-violet-800"
    },
    {
      title: "Search with Autocomplete",
      description: "Real-time search with autocomplete suggestions using Stimulus controllers and debounced fetch requests.",
      category: "UI",
      tags: %w[search autocomplete stimulus]
    },
    {
      title: "User Authentication",
      description: "Complete authentication flow with login, registration, password reset, and session management.",
      category: "Auth",
      tags: %w[authentication session password],
      cover_tone: "from-rose-950 via-rose-900 to-pink-800"
    },
    {
      title: "Image Upload with Preview",
      description: "Drag-and-drop image upload with live preview, progress bar, and Active Storage integration.",
      category: "CRUD",
      tags: %w[upload image storage],
      cover_tone: "from-emerald-950 via-emerald-900 to-teal-800"
    },
    {
      title: "Pagination & Infinite Scroll",
      description: "Paginate large result sets with classic page numbers and seamless infinite scroll using Hotwire.",
      category: "UI",
      tags: %w[pagination infinite-scroll stimulus],
      cover_tone: "from-amber-950 via-amber-900 to-yellow-800"
    },
    {
      title: "API Token Authentication",
      description: "Secure your API with token-based authentication, rate limiting, and request validation.",
      category: "API",
      tags: %w[api rest authentication],
      cover_tone: "from-cyan-950 via-cyan-900 to-sky-800"
    },
    {
      title: "Inline Editing",
      description: "Click-to-edit any field on the page with automatic save using Turbo Frames and optimistic UI updates.",
      category: "CRUD",
      tags: %w[form stimulus turbo],
      cover_tone: "from-orange-950 via-orange-900 to-amber-800"
    },
    {
      title: "Notification Toast System",
      description: "Display real-time toast notifications with auto-dismiss, stacking, and action callbacks.",
      category: "UI",
      tags: %w[notification toast stimulus],
      cover_tone: "from-blue-950 via-blue-900 to-indigo-800"
    }
  ].freeze

  def home
    render Views::Pages::Home.new(
      featured_examples: self.class::EXAMPLES.first(3),
      categories: self.class::EXAMPLES.map { |e| e[:category] }.uniq.sort
    )
  end

  def examples
    @examples = self.class::EXAMPLES
    @categories = @examples.map { |e| e[:category] }.uniq.sort
    @tags = @examples.flat_map { |e| e[:tags] }.uniq.sort
    @selected_category = params[:category]
    @selected_tag = params[:tag]

    @examples = @examples.select { |e| e[:category] == @selected_category } if @selected_category.present?
    @examples = @examples.select { |e| e[:tags].include?(@selected_tag) } if @selected_tag.present?

    render Views::Pages::Examples.new(
      examples: @examples,
      categories: @categories,
      tags: @tags,
      selected_category: @selected_category,
      selected_tag: @selected_tag
    )
  end
end
