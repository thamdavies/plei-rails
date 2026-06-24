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

  def cover_image
    tone = @example[:cover_tone] || "from-slate-950 via-slate-900 to-slate-700"
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
      h3(class: "font-semibold leading-snug") { @example[:title] }
      p(class: "mt-1 text-sm text-muted-foreground line-clamp-2") { @example[:description] }
    end
  end

  def category_badge
    RubyUI::Badge(variant: :secondary, size: :sm) { @example[:category] }
  end

  def tag_group
    div(class: "flex flex-wrap gap-1.5") do
      @example[:tags].each do |tag|
        span(class: "inline-flex items-center rounded-md bg-muted px-1.5 py-0.5 text-xs font-medium text-muted-foreground") do
          plain "##{tag}"
        end
      end
    end
  end

  def author_section
    div(class: "mt-auto flex items-center gap-2 pt-2") do
      RubyUI::Avatar(size: :sm, class: "ring-1 ring-border") do
        RubyUI::AvatarFallback { "CJ" }
      end
      span(class: "text-xs text-muted-foreground") { "Collin Jilbert" }
    end
  end
end
