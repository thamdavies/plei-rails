class Components::ExampleCard < Components::Base
  def initialize(example:)
    @example = example
  end

  def view_template
    article(class: "group relative flex flex-col overflow-hidden rounded-xl border bg-background shadow-sm transition-all hover:shadow-md") do
      cover_image
      body
    end
  end

  private

  COVER_TONES = {
    "CRUD" => "from-indigo-950 via-indigo-900 to-violet-800",
    "UI" => "from-amber-950 via-amber-900 to-yellow-800",
    "Auth" => "from-rose-950 via-rose-900 to-pink-800",
    "API" => "from-cyan-950 via-cyan-900 to-sky-800"
  }.freeze

  def cover_image
    tone = COVER_TONES[@example.category.name] || "from-slate-950 via-slate-900 to-slate-700"
    a(href: example_path(@example), class: "block") do
      div(class: "bg-gradient-to-br #{tone} flex aspect-video items-center justify-center") do
        svg(
          xmlns: "http://www.w3.org/2000/svg",
          viewbox: "0 0 24 24",
          fill: "none",
          stroke: "currentColor",
          class: "h-10 w-10 text-white/40"
        ) do |s|
          s.path(
            stroke_linecap: "round",
            stroke_linejoin: "round",
            d: "m6.75 7.5 3 2.25-3 2.25m4.5 0h3m-9 8.25h13.5A2.25 2.25 0 0 0 21 18V6a2.25 2.25 0 0 0-2.25-2.25H5.25A2.25 2.25 0 0 0 3 6v12a2.25 2.25 0 0 0 2.25 2.25Z"
          )
        end
      end
    end
  end

  def body
    div(class: "flex flex-1 flex-col gap-3 p-4") do
      header_section
      category_badge
      tag_group
      author_section
    end
  end

  def header_section
    div do
      a(href: example_path(@example), class: "hover:underline") do
        h3(class: "font-semibold leading-snug") { @example.title }
      end
      p(class: "mt-1 text-sm text-muted-foreground line-clamp-2") { @example.description }
    end
  end

  def category_badge
    RubyUI::Badge(variant: :secondary, size: :sm) { @example.category.name }
  end

  def tag_group
    div(class: "flex flex-wrap gap-1.5") do
      @example.tags.each do |tag|
        a(
          href: examples_path(tag: tag.slug),
          class: "inline-flex items-center rounded-md bg-muted px-1.5 py-0.5 text-xs font-medium text-muted-foreground hover:bg-accent hover:text-accent-foreground transition-colors"
        ) do
          plain "##{tag.name}"
        end
      end
    end
  end

  def author_section
    div(class: "mt-auto flex items-center gap-2 pt-2") do
      RubyUI::Avatar(size: :sm, class: "ring-1 ring-border") do
        RubyUI::AvatarFallback { @example.author.username.first(2).upcase }
      end
      span(class: "text-xs text-muted-foreground") { @example.author.username }
    end
  end
end
