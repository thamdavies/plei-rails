class Views::Pages::Home < Views::Base
  def initialize(featured_examples:, categories:)
    @featured_examples = featured_examples
    @categories = categories
  end

  def view_template
    hero_section
    # featured_section
    categories_section
    # cta_section
  end

  private

  def hero_section
    section(class: "relative overflow-hidden border-b") do
      # Base gradient
      div(class: "absolute inset-0 bg-gradient-to-b from-brand/3 via-transparent to-background")

      # Decorative gradient orbs
      div(class: "absolute inset-0 overflow-hidden pointer-events-none") do
        div(
          class: "absolute -top-40 -right-40 h-[500px] w-[500px] md:h-[600px] md:w-[600px] rounded-full opacity-[0.08]",
          style: "background: radial-gradient(circle at center, #d32030 0%, transparent 70%)"
        )
        div(
          class: "absolute -bottom-40 -left-40 h-[400px] w-[400px] md:h-[500px] md:w-[500px] rounded-full opacity-[0.06]",
          style: "background: radial-gradient(circle at center, #d32030 0%, transparent 70%)"
        )
      end

      # Subtle dot pattern
      div(
        class: "absolute inset-0 opacity-[0.03] pointer-events-none",
        style: "background-image: radial-gradient(circle, #d32030 1px, transparent 1px); background-size: 32px 32px"
      )

      div(class: "container relative py-20 md:py-32") do
        div(class: "mx-auto max-w-3xl text-center") do
          # Badge with live indicator
          div(class: "mb-6 inline-flex items-center gap-2 rounded-full border border-brand/20 bg-brand/[0.04] px-4 py-1.5 text-xs font-medium text-brand") do
            span(class: "relative flex h-2 w-2") do
              span(class: "absolute inline-flex h-full w-full animate-ping rounded-full bg-brand/40")
              span(class: "relative inline-flex h-2 w-2 rounded-full bg-brand")
            end
            plain "Hands-on Rails examples for developers"
          end

          h1(class: "text-4xl font-bold tracking-tight md:text-5xl lg:text-6xl") do
            span(class: "text-brand") { "Learn" }
            plain " Rails by "
            span(class: "text-brand") { "Example" }
          end

          p(class: "mt-6 max-w-2xl mx-auto text-lg text-muted-foreground md:text-xl") do
            plain "Real, runnable Rails examples that teach you one concept at a time. From CRUD to APIs — learn by building."
          end

          div(class: "mt-10 flex flex-col items-center justify-center gap-4 sm:flex-row") do
            Link(
              href: examples_path,
              variant: :primary,
              size: :lg,
              class: "w-full sm:w-auto bg-brand hover:bg-brand/90 shadow-lg shadow-brand/20"
            ) do
              "Browse Examples"
            end
            Link(href: "https://github.com/thamdavies/plei-rails", variant: :outline, size: :lg, class: "w-full sm:w-auto") do
              "GitHub"
            end
          end
        end
      end
    end
  end

  def featured_section
    section(class: "py-16 md:py-20") do
      div(class: "container") do
        div(class: "mb-10 text-center") do
          h2(class: "text-2xl font-bold tracking-tight md:text-3xl") { "Featured Examples" }
          p(class: "mt-2 text-muted-foreground") { "Jump straight into a working example and start exploring." }
        end
        div(class: "grid gap-6 sm:grid-cols-2 lg:grid-cols-3") do
          @featured_examples.each do |example|
            Components::ExampleCard(example: example)
          end
        end
        div(class: "mt-8 text-center") do
          Link(href: examples_path, variant: :link, size: :lg) do
            plain "View all examples"
            span(class: "ml-1") { "→" }
          end
        end
      end
    end
  end

  def categories_section
    section(class: "border-t bg-muted/50 py-16 md:py-20") do
      div(class: "container") do
        div(class: "mb-10 text-center") do
          h2(class: "text-2xl font-bold tracking-tight md:text-3xl") { "Browse by Category" }
          p(class: "mt-2 text-muted-foreground") { "Each category groups related examples so you can focus on what matters." }
        end
        div(class: "grid gap-4 sm:grid-cols-2 lg:grid-cols-4") do
          @categories.each do |category|
            render category_card(category)
          end
        end
      end
    end
  end

  def category_card(category)
    tones = {
      "CRUD" => { gradient: "from-indigo-500/10 via-indigo-500/5 to-transparent", border: "border-indigo-200 dark:border-indigo-900", icon: "M2.25 15.75l5.159-5.159a2.25 2.25 0 013.182 0l5.159 5.159m-1.5-1.5l1.409-1.41a2.25 2.25 0 013.182 0l2.909 2.91m-18 3.75h16.5a1.5 1.5 0 001.5-1.5V6a1.5 1.5 0 00-1.5-1.5H3.75A1.5 1.5 0 002.25 6v12a1.5 1.5 0 001.5 1.5zm10.5-11.25h.008v.008h-.008V8.25zm.375 0a.375.375 0 11-.75 0 .375.375 0 01.75 0z" },
      "UI" => { gradient: "from-amber-500/10 via-amber-500/5 to-transparent", border: "border-amber-200 dark:border-amber-900", icon: "M9.53 16.122a3 3 0 00-5.78 1.128 2.25 2.25 0 01-2.4 2.245 4.5 4.5 0 008.4-2.245c0-.399-.078-.78-.22-1.128zm0 0a15.998 15.998 0 003.388-1.62m-5.043-.025a15.994 15.994 0 011.622-3.395m3.42 3.42a15.995 15.995 0 004.764-4.648l3.876-5.814a1.151 1.151 0 00-1.597-1.597L14.146 6.32a15.996 15.996 0 00-4.649 4.763m3.42 3.42a6.776 6.776 0 00-3.42-3.42" },
      "Auth" => { gradient: "from-rose-500/10 via-rose-500/5 to-transparent", border: "border-rose-200 dark:border-rose-900", icon: "M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" },
      "API" => { gradient: "from-cyan-500/10 via-cyan-500/5 to-transparent", border: "border-cyan-200 dark:border-cyan-900", icon: "M12 21a9.004 9.004 0 008.716-6.747M12 21a9.004 9.004 0 01-8.716-6.747M12 21c2.485 0 4.5-4.03 4.5-9S14.485 3 12 3m0 18c-2.485 0-4.5-4.03-4.5-9S9.515 3 12 3m0 0a8.997 8.997 0 017.843 4.582M12 3a8.997 8.997 0 00-7.843 4.582m15.686 0A11.953 11.953 0 0112 10.5c-2.998 0-5.74-1.1-7.843-2.918m15.686 0A8.959 8.959 0 0121 12c0 .778-.099 1.533-.284 2.253m0 0A17.919 17.919 0 0112 16.5c-3.162 0-6.133-.815-8.716-2.247m0 0A9.015 9.015 0 013 12c0-1.605.42-3.113 1.157-4.418" }
    }
    tone = tones[category] || tones["CRUD"]

    a(
      href: examples_path(category: category),
      class: "group relative rounded-xl border #{tone[:border]} bg-background p-5 shadow-sm transition-all hover:shadow-md"
    ) do
      div(class: "mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-gradient-to-br #{tone[:gradient]}") do
        svg(xmlns: "http://www.w3.org/2000/svg", viewbox: "0 0 24 24", fill: "none", stroke: "currentColor", class: "h-6 w-6 text-foreground") do |s|
          s.path(stroke_linecap: "round", stroke_linejoin: "round", d: tone[:icon])
        end
      end
      h3(class: "font-semibold") { category }
      p(class: "mt-1 text-sm text-muted-foreground") do
        plain "#{PagesController::EXAMPLES.count { |e| e[:category] == category }} examples"
      end
    end
  end

  def cta_section
    section(class: "border-t py-16 md:py-20") do
      div(class: "container") do
        div(class: "mx-auto max-w-xl rounded-xl border bg-gradient-to-br from-primary/5 via-primary/[0.02] to-transparent p-10 text-center shadow-sm") do
          h2(class: "text-2xl font-bold tracking-tight md:text-3xl") { "Ready to start building?" }
          p(class: "mt-2 text-muted-foreground") { "Pick an example, read the code, run it yourself. That's how you learn Rails." }
          div(class: "mt-6") do
            Link(href: examples_path, variant: :primary, size: :lg, class: "w-full sm:w-auto") do
              plain "Explore all examples"
              span(class: "ml-1.5") { "→" }
            end
          end
        end
      end
    end
  end
end
