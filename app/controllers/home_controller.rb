class HomeController < ApplicationController
  def index
    @playlist = params[:playlist].presence_in(MusicCatalog::PLAYLISTS)
    @artist = params[:artist].presence_in(MusicCatalog::FOLLOWED_ARTISTS.map { |artist| artist[:name] })
    @query = params[:q].to_s.strip
    @view = params[:view].presence_in(%w[browse library charts new for-you])
    @title = @artist || @playlist || { "browse" => "Browse", "library" => "My Library", "charts" => "Charts", "new" => "New Releases", "for-you" => "For You" }.fetch(@view, "All Tracks")
    @tracks = MusicCatalog::TRACKS
    @tracks = @tracks.select { |track| track[:artist] == @artist } if @artist
    @tracks = @tracks.select { |track| track[:playlist] == @playlist } if @playlist
    @tracks = @tracks.select { |track| [ track[:title], track[:artist], track[:playlist] ].join(" ").downcase.include?(@query.downcase) } if @query.present?
  end
end
