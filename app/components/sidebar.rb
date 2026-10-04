# frozen_string_literal: true

class Components::Sidebar < Components::Base
  def initialize(playlist: nil, view: nil, artist: nil, followed_artists: MusicCatalog::FOLLOWED_ARTISTS)
    @playlist, @view, @artist = playlist, view, artist
    @followed_artists = followed_artists
  end

  def view_template
    SidebarWrapper(class: "[--sidebar-width:216px]! motion-reduce:[&_*]:transition-none") do
      render RubyUI::Sidebar.new(collapsible: :offcanvas, aria_label: "Main navigation") do
        SidebarHeader(class: "px-3 pb-0") do
          a(href: root_path, class: "flex h-12 items-center gap-2.5 px-2 text-xl font-bold") do
            Hero::MusicalNoteOutline(class: "size-6 shrink-0")
            span { "Plei Music" }
          end
          div(class: "flex items-center gap-2 rounded-xl bg-muted p-3") do
            Avatar do
              AvatarFallback { "TD" }
            end

            div do
              strong(class: "block text-sm font-semibold") { "Tham Davies" }
              small(class: "block text-xs text-muted-foreground") { "Premium Plan" }
            end
          end
        end
        SidebarContent do
          SidebarGroup(class: "px-3 pt-4") do
            nav(aria_label: "Main navigation") do
              SidebarMenu do
                menu_link("Browse", "HomeOutline", root_path(view: "browse"), @view == "browse")
                menu_link("My Library", "RectangleStackOutline", root_path(view: "library"), @view == "library")
                menu_link("All Tracks", "QueueListOutline", root_path, @playlist.nil? && @view.nil? && @artist.nil?)
              end
            end
          end
        end
        Separator()
        SidebarFooter(class: "px-3 pb-5 pt-3") do
          SidebarGroup(class: "p-0") do
            SidebarGroupLabel(class: "uppercase tracking-wider text-[11px]") { "Following artists" }
            SidebarMenu do
              @followed_artists.each do |artist|
                SidebarMenuItem do
                  SidebarMenuButton(as: :a, href: root_path(artist: artist[:name]), active: @artist == artist[:name],
                    class: "h-11 gap-2.5 text-[13px] text-muted-foreground data-[active=true]:text-sidebar-accent-foreground", aria_current: (@artist == artist[:name] ? "page" : nil)) do
                    img(class: "size-8 shrink-0 rounded-full object-cover", src: artist[:avatar], alt: "", width: 32, height: 32)
                    span { artist[:name] }
                  end
                end
              end
            end
          end
        end
      end
      SidebarInset(class: "min-w-0") do
        yield if block_given?
      end
    end
  end

  private

  def menu_link(label, icon, href, active)
    SidebarMenuItem do
      SidebarMenuButton(as: :a, href: href, active: active, class: "h-11 gap-3 rounded-lg text-muted-foreground data-[active=true]:text-sidebar-accent-foreground",
        aria_current: (active ? "page" : nil)) do
        render Hero.const_get(icon).new(class: "size-4 shrink-0")
        span { label }
      end
    end
  end
end
