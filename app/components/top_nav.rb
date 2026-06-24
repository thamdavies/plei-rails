# frozen_string_literal: true

class Components::TopNav < Components::Base
  include Phlex::Rails::Helpers::ImageTag

  def view_template
    header(class: "sticky top-0 z-40 border-b border-border/70 bg-background/90 backdrop-blur") do
      div(class: "mx-auto flex h-16 w-full items-center justify-between gap-4 px-8") do
        div(class: "flex items-center gap-8") do
          a(href: root_path, class: "inline-flex items-center gap-2") do
            image_tag "logo.svg", alt: "Plei Rails Logo", class: "h-8 w-auto dark:hidden"
            image_tag "logo.svg", alt: "Plei Rails Logo", class: "hidden h-8 w-auto dark:block dark:brightness-0 dark:invert"
          end

          nav(class: "hidden items-center gap-2 md:flex") do
            render Link.new(href: examples_path, variant: :ghost, class: "font-semibold text-primary") { "Examples" }
            render Link.new(href: "https://github.com/thamdavies/plei-rails", variant: :ghost, target: "_blank") { "Github" }
          end
        end

        div(class: "flex items-center gap-3") do
          CommandDialog do
            CommandDialogTrigger do
              Button(variant: "outline", class: "w-56 pr-2 pl-3 justify-between") do
                div(class: "flex items-center space-x-1") do
                  search_icon
                  span(class: "text-muted-foreground font-normal") do
                    plain "Search"
                  end
                end
                ShortcutKey do
                  span(class: "text-xs") { "⌘" }
                  plain "K"
                end
              end
            end
            CommandDialogContent do
              Command do
                CommandInput(placeholder: "Type a command or search...")
                CommandEmpty { "No results found." }
                CommandList do
                  CommandGroup(title: "Components") do
                    components_list.each do |component|
                      CommandItem(value: component[:name], href: component[:path]) do
                        default_icon
                        plain component[:name]
                      end
                    end
                  end
                  CommandGroup(title: "Settings") do
                    settings_list.each do |setting|
                      CommandItem(value: setting[:name], href: setting[:path]) do
                        default_icon
                        plain setting[:name]
                      end
                    end
                  end
                end
              end
            end
          end

          # render Link.new(href: "#", variant: :ghost, class: "hidden sm:inline-flex") { "Pricing" }
          #
          ThemeToggle do
            svg(
              xmlns: "http://www.w3.org/2000/svg",
              viewbox: "0 0 24 24",
              fill: "currentColor",
              class: "w-4 h-4 dark:hidden"
            ) do |s|
              s.path(
                d:
                  "M12 2.25a.75.75 0 01.75.75v2.25a.75.75 0 01-1.5 0V3a.75.75 0 01.75-.75zM7.5 12a4.5 4.5 0 119 0 4.5 4.5 0 01-9 0zM18.894 6.166a.75.75 0 00-1.06-1.06l-1.591 1.59a.75.75 0 101.06 1.061l1.591-1.59zM21.75 12a.75.75 0 01-.75.75h-2.25a.75.75 0 010-1.5H21a.75.75 0 01.75.75zM17.834 18.894a.75.75 0 001.06-1.06l-1.59-1.591a.75.75 0 10-1.061 1.06l1.59 1.591zM12 18a.75.75 0 01.75.75V21a.75.75 0 01-1.5 0v-2.25A.75.75 0 0112 18zM7.758 17.303a.75.75 0 00-1.061-1.06l-1.591 1.59a.75.75 0 001.06 1.061l1.591-1.59zM6 12a.75.75 0 01-.75.75H3a.75.75 0 010-1.5h2.25A.75.75 0 016 12zM6.697 7.757a.75.75 0 001.06-1.06l-1.59-1.591a.75.75 0 00-1.061 1.06l1.59 1.591z"
              )
            end
            svg(
              xmlns: "http://www.w3.org/2000/svg",
              viewbox: "0 0 24 24",
              fill: "currentColor",
              class: "w-4 h-4 hidden dark:inline-block"
            ) do |s|
              s.path(
                fill_rule: "evenodd",
                d:
                  "M9.528 1.718a.75.75 0 01.162.819A8.97 8.97 0 009 6a9 9 0 009 9 8.97 8.97 0 003.463-.69.75.75 0 01.981.98 10.503 10.503 0 01-9.694 6.46c-5.799 0-10.5-4.701-10.5-10.5 0-4.368 2.667-8.112 6.46-9.694a.75.75 0 01.818.162z",
                clip_rule: "evenodd"
              )
            end
          end


          render Avatar.new(class: "ring-1 ring-border") do
            render AvatarFallback.new { "TH" }
          end
        end
      end
    end
  end

  private

  def default_icon
    svg(
      xmlns: "http://www.w3.org/2000/svg",
      viewbox: "0 0 24 24",
      fill: "currentColor",
      class: "w-5 h-5"
    ) do |s|
      s.path(
        fill_rule: "evenodd",
        d:
          "M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25zm4.28 10.28a.75.75 0 000-1.06l-3-3a.75.75 0 10-1.06 1.06l1.72 1.72H8.25a.75.75 0 000 1.5h5.69l-1.72 1.72a.75.75 0 101.06 1.06l3-3z",
        clip_rule: "evenodd"
      )
    end
  end

  def search_icon
    svg(
      xmlns: "http://www.w3.org/2000/svg",
      viewbox: "0 0 20 20",
      fill: "currentColor",
      class: "w-4 h-4 mr-1.5"
    ) do |s|
      s.path(
        fill_rule: "evenodd",
        d:
          "M9 3.5a5.5 5.5 0 100 11 5.5 5.5 0 000-11zM2 9a7 7 0 1112.452 4.391l3.328 3.329a.75.75 0 11-1.06 1.06l-3.329-3.328A7 7 0 012 9z",
        clip_rule: "evenodd"
      )
    end
  end

  def components_list
    [
      { name: "Accordion", path: "#" },
      { name: "Alert", path: "#" },
      { name: "Alert Dialog", path: "#" },
      { name: "Aspect Ratio", path: "#" },
      { name: "Avatar", path: "#" },
      { name: "Badge", path: "#" }
    ]
  end

  def settings_list
    [
      { name: "Profile", path: "#" },
      { name: "Mail", path: "#" },
      { name: "Settings", path: "#" }
    ]
  end
end
