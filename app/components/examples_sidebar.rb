class Components::ExamplesSidebar < Components::Base
  def initialize(categories:, tags:, selected_category:, selected_tag:)
    @categories = categories
    @tags = tags
    @selected_category = selected_category
    @selected_tag = selected_tag
  end

  def view_template
    aside(class: "w-full shrink-0 lg:w-56") do
      category_section
      div(class: "my-6 border-t") if @tags.any?
      tag_section if @tags.any?
    end
  end

  private

  def category_section
    div do
      h4(class: "mb-3 text-sm font-semibold") { "Categories" }
      ul(class: "space-y-1") do
        li { filter_link(nil, "All", @selected_category.nil? && @selected_tag.nil?) }
        @categories.each do |category|
          li { filter_link(category.slug, category.name, @selected_category == category.slug) }
        end
      end
    end
  end

  def tag_section
    div(class: "mt-6") do
      h4(class: "mb-3 text-sm font-semibold") { "Tags" }
      div(class: "flex flex-wrap gap-1.5 lg:flex-col lg:flex-nowrap") do
        @tags.each do |tag|
          tag_link(tag)
        end
      end
    end
  end

  def filter_link(category, label, active)
    a(
      href: category.present? ? examples_path(category:) : examples_path,
      class: [
        "block rounded-md px-3 py-1.5 text-sm transition-colors",
        active ? "bg-primary text-primary-foreground font-medium" : "text-muted-foreground hover:bg-accent hover:text-accent-foreground"
      ]
    ) { label }
  end

  def tag_link(tag)
    active = @selected_tag == tag.slug
    a(
      href: examples_path(tag: tag.slug),
      class: [
        "inline-flex items-center rounded-md px-2 py-1 text-xs font-medium transition-colors lg:block",
        active \
          ? "bg-primary text-primary-foreground" \
          : "bg-muted text-muted-foreground hover:bg-accent hover:text-accent-foreground"
      ]
    ) do
      plain "##{tag.name}"
    end
  end
end
