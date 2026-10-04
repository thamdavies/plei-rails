# frozen_string_literal: true

# Preview content until tracks are backed by a database model.
class MusicCatalog
  FOLLOWED_ARTISTS = [
    { name: "SoundHelix", avatar: "/artwork/cover-0.svg" },
    { name: "ElectroVibes", avatar: "/artwork/cover-1.svg" },
    { name: "ChillBeats", avatar: "/artwork/cover-2.svg" },
    { name: "PopFusion", avatar: "/artwork/cover-3.svg" },
    { name: "UrbanGroove", avatar: "/artwork/cover-4.svg" }
  ].freeze
  PLAYLISTS = [ "Today's Top Hits", "Pop Hits", "Workout", "Chill Hits" ].freeze
  TRACKS = [
    [ "Electronic Dreams", "Today's Top Hits", "6:12" ],
    [ "Night Drive", "Chill Hits", "4:49" ],
    [ "Summer Vibes", "Pop Hits", "6:55" ],
    [ "Midnight Blues", "Chill Hits", "5:33" ],
    [ "Power Up", "Workout", "4:58" ],
    [ "Chill Out", "Chill Hits", "5:52" ],
    [ "Urban Beats", "Today's Top Hits", "6:28" ],
    [ "Acoustic Sessions", "Pop Hits", "6:41" ],
    [ "Dance Floor", "Pop Hits", "4:25" ],
    [ "Sunset Groove", "Chill Hits", "5:20" ],
    [ "Deep Focus", "Today's Top Hits", "7:25" ],
    [ "Electric Pulse", "Workout", "5:10" ]
  ].each_with_index.map { |(title, playlist, duration), index|
    { title: title, artist: "SoundHelix", playlist: playlist, duration: duration, artwork: "/artwork/cover-#{index % 6}.svg" }.freeze
  }.freeze
end
