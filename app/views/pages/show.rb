class Views::Pages::Show < Views::Base
  def initialize(post:)
    @post = post
  end

  def view_template
    div(class: "container py-8") do
      Link(href: examples_path, variant: :link, class: "mb-6 inline-flex items-center gap-1 text-sm") do
        plain "← Back to examples"
      end

      article(class: "mx-auto max-w-3xl") do
        div(class: "mb-8") do
          RubyUI::Badge(variant: :secondary, size: :sm) { @post.category.name }
          h1(class: "mt-4 text-4xl font-bold tracking-tight") { @post.title }
          p(class: "mt-2 text-lg text-muted-foreground") { @post.description } if @post.description

          div(class: "mt-4 flex items-center gap-3 text-sm text-muted-foreground") do
            RubyUI::Avatar(size: :sm, class: "ring-1 ring-border") do
              RubyUI::AvatarFallback { @post.author.username.first(2).upcase }
            end
            plain @post.author.username
            plain "·"
            time(datetime: @post.created_at.iso8601) { @post.created_at.strftime("%B %d, %Y") }
          end

          if @post.tags.any?
            div(class: "mt-4 flex flex-wrap gap-1.5") do
              @post.tags.each do |tag|
                a(
                  href: examples_path(tag: tag.slug),
                  class: "inline-flex items-center rounded-md bg-muted px-2 py-0.5 text-xs font-medium text-muted-foreground hover:bg-accent hover:text-accent-foreground transition-colors"
                ) do
                  plain "##{tag.name}"
                end
              end
            end
          end
        end

        div(class: "prose prose-gray max-w-none dark:prose-invert") do
          if @post.summary.present?
            h2(class: "text-xl font-semibold") { "Summary" }
            p { @post.summary }
          end

          if @post.body.present?
            div(class: "mt-6 rounded-lg border bg-muted/30 p-6") do
              h3(class: "text-sm font-medium text-muted-foreground mb-2") { "Example Code" }
              pre(class: "overflow-x-auto text-sm") { @post.body }
            end
          end
        end
      end
    end
  end
end
