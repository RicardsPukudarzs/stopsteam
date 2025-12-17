class GamesController < ApplicationController
  before_action :require_logged_in

  def show
    app_id = params[:app_id]

    music_service = GameMusicService.new(app_id)
    @top_artists = music_service.top_artists
    @top_tracks = music_service.top_tracks

    game_details = SteamApi.new.fetch_game_details(app_id)
    details_service = GameDetailsService.new(game_details)
    @name = details_service.name
    @short_desc = details_service.short_description
    @header_img = details_service.header_image
    @price = details_service.price
    @categories = details_service.categories
    @release_date = details_service.release_date
    @developers = details_service.developers
    @publishers = details_service.publishers
  end
end
