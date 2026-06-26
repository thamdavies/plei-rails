class Views::Examples::Show < Views::Base
  def initialize(post:)
    @post = post
  end

  def view_template
    div(class: "container py-8") do
      Link(href: examples_path, variant: :link, class: "mb-6") do
        plain "← Back to examples"
      end

      article(class: "mx-auto max-w-3xl") do
        section(class: "space-y-4") do
          Badge(variant: :secondary, size: :sm, class: "w-fit") { @post.category.name }
          Heading(level: 1, size: "8") { @post.title }
          Text(size: "4", weight: "muted") { @post.description } if @post.description
          meta_row
          tags_row if @post.tags.any?
        end

        Separator(class: "my-6")

        section(class: "space-y-6") do
          if @post.summary.present?
            section(class: "space-y-2") do
              Heading(level: 2, size: "5") { "Summary" }
              Text(class: "leading-7") { @post.summary }
            end
          end

          if @post.body.present?
            section(class: "space-y-2") do
              Heading(level: 3, size: "3", class: "text-muted-foreground") { "Example Code" }
              Codeblock(@post.body, syntax: :ruby)
            end
          end
        end
      end
    end
  end

  private

  def meta_row
    div(class: "mt-4 flex items-center gap-3") do
      Avatar(size: :sm, class: "ring-1 ring-border") do
        AvatarFallback { @post.author.username.first(2).upcase }
      end

      Text(size: "2", weight: "muted") { @post.author.username }
      Text(size: "2", weight: "muted") { "•" }
      Text(size: "2", weight: "muted") do
        time(datetime: @post.created_at.iso8601) { @post.created_at.strftime("%B %d, %Y") }
      end
    end
  end

  def tags_row
    div(class: "mt-4 flex flex-wrap gap-2") do
      @post.tags.each do |tag|
        Link(href: examples_path(tag: tag.slug), variant: :outline, size: :sm) do
          plain "##{tag.name}"
        end
      end
    end
  end
end
