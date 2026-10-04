# frozen_string_literal: true

class Components::TopNav < Components::Base
  def initialize(query: nil, playlist: nil, view: nil)
    @query, @playlist, @view = query, playlist, view
  end

  def view_template
    header(class: "sticky top-0 z-10 flex flex-col gap-3 border-b bg-background px-4 py-3 md:flex-row md:items-center md:justify-between md:px-6") do
      div(class: "flex min-w-0 items-center gap-3") do
        SidebarTrigger(class: "h-11 w-11 shrink-0 md:hidden", aria_label: "Toggle sidebar")
        nav(aria_label: "Discover music", class: "flex min-w-0 gap-5 overflow-x-auto md:gap-6") do
          { "Browse" => "browse", "Charts" => "charts", "New Releases" => "new", "For You" => "for-you" }.each do |label, value|
            a(href: root_path(view: value), class: "flex min-h-11 shrink-0 items-center whitespace-nowrap text-[13px] text-muted-foreground hover:text-foreground focus-visible:rounded-sm focus-visible:outline-2 focus-visible:outline-ring aria-[current=page]:font-semibold aria-[current=page]:text-foreground", aria_current: (@view == value ? "page" : nil)) { label }
          end
        end
      end
      form(action: root_path, method: "get", role: "search") do
        CommandDialog do
          CommandDialogTrigger do
            Button(variant: "outline", class: "w-full justify-between pr-2 pl-3 md:w-56") do
              div(class: "flex items-center space-x-1") do
                Hero::MagnifyingGlassOutline(class: "size-4 shrink-0")
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
                CommandGroup(title: "People") do
                  people_list.each do |person|
                    CommandItem(value: person[:name], href: person[:path]) do
                      plain person[:name]
                    end
                  end
                end
                CommandGroup(title: "Tracks") do
                  tracks.each do |track|
                    CommandItem(value: track[:name], href: track[:path]) do
                      plain track[:name]
                    end
                  end
                end
              end
            end
          end
        end
      end
      yield if block_given?
    end
  end

  private

  def people_list
    [
      { name: "Vladimir Raksha", path: root_path },
      { name: "Jane Doe", path: root_path },
      { name: "John Smith", path: root_path }
    ]
  end

  def tracks
    MusicCatalog::TRACKS.map do |track|
      { name: "#{track[:title]} - #{track[:artist]}", path: root_path }
    end
  end
end
