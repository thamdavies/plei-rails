class Views::Pages::Examples < Views::Base
  def initialize(examples:, categories:, tags:, selected_category:, selected_tag:)
    @examples = examples
    @categories = categories
    @tags = tags
    @selected_category = selected_category
    @selected_tag = selected_tag
  end

  def view_template
    div(class: "container py-8") do
      div(class: "mb-8") do
        h1(class: "text-3xl font-bold tracking-tight") { "Examples" }
        p(class: "text-muted-foreground mt-1") { "Browse ready-to-run examples and learn by doing." }
      end

      div(class: "flex flex-col gap-8 lg:flex-row") do
        render Components::ExamplesSidebar.new(
          categories: @categories,
          tags: @tags,
          selected_category: @selected_category,
          selected_tag: @selected_tag
        )

        div(class: "flex-1 min-w-0") do
          if @examples.any?
            div(class: "grid gap-6 sm:grid-cols-2 xl:grid-cols-3") do
              @examples.each do |example|
                render Components::ExampleCard.new(example: example)
              end
            end
          else
            div(class: "flex flex-col items-center justify-center rounded-xl border border-dashed py-16 text-center") do
              svg(xmlns: "http://www.w3.org/2000/svg", viewbox: "0 0 24 24", fill: "none", stroke: "currentColor", class: "mb-4 h-12 w-12 text-muted-foreground") do |s|
                s.path(stroke_linecap: "round", stroke_linejoin: "round", d: "M9.75 3.104v5.714a2.25 2.25 0 0 1-.659 1.591L5 14.5M9.75 3.104c-.251.023-.501.05-.75.082m.75-.082a24.301 24.301 0 0 1 4.5 0m0 0v5.714c0 .597.237 1.17.659 1.591L19.8 15.3M14.25 3.104c.251.023.501.05.75.082M19.8 15.3l-1.57.393A9.065 9.065 0 0 1 12 15a9.065 9.065 0 0 0-6.23.693L5 14.5m14.8.8 1.402 1.402c1.232 1.232.65 3.318-1.067 3.611A48.309 48.309 0 0 1 12 21c-2.773 0-5.491-.235-8.135-.687-1.718-.293-2.3-2.379-1.067-3.61L5 14.5")
              end
              h3(class: "text-lg font-semibold") { "No examples found" }
              p(class: "mt-1 text-sm text-muted-foreground") do
                plain "Try adjusting your filters to see more results."
              end
            end
          end
        end
      end
    end
  end
end
