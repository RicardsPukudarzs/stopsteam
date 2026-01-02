class GamesController < ApplicationController
  # Nodrošina, ka spēles detaļu lapai var piekļūt tikai pieslēgti lietotāji
  before_action :require_logged_in

  def show
    # Iegūst spēles identifikatoru (app_id) no pieprasījuma parametriem
    app_id = params[:app_id]

    music_service = GameMusicService.new(app_id) # Inicializē servisa klasi, kas iegūst ar spēli saistīto mūziku

    # Vispopulārākie izpildītāji un dziesmas, kas saistītas ar konkrēto spēli
    @top_artists = music_service.top_artists
    @top_tracks = music_service.top_tracks

    # Iegūst spēles detalizēto informāciju no Steam API
    game_details = SteamApi.new.fetch_game_details(app_id)

    # Inicializē servisa klasi spēles datu apstrādei un strukturēšanai
    details_service = GameDetailsService.new(game_details)

    # Spēles pamatinformācija, kas tiek nodota skatījumam (view)
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
