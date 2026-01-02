class DashboardsController < ApplicationController
  # Nodrošina, ka dashboard lapai var piekļūt tikai pieslēgti lietotāji
  before_action :require_logged_in

  def index
    @spotify_user = current_user.spotify_user # Iegūst ar lietotāju saistīto Spotify kontu
    if @spotify_user # Ja Spotify konts ir piesaistīts, tiek iegūti klausīšanās statistikas dati

      # Visklausītākie izpildītāji dažādos laika periodos
      @top_artists_last_year = @spotify_user.top_artists_by_period('last_year')
      @top_artists_last_6_months = @spotify_user.top_artists_by_period('6_months')
      @top_artists_last_4_weeks = @spotify_user.top_artists_by_period('4_weeks')

      # Visklausītākās dziesmas dažādos laika periodos
      @top_songs_last_year = @spotify_user.top_songs_by_period('last_year')
      @top_songs_last_6_months = @spotify_user.top_songs_by_period('6_months')
      @top_songs_last_4_weeks = @spotify_user.top_songs_by_period('4_weeks')
    end

    @steam_user = current_user.steam_user # Iegūst ar lietotāju saistīto Steam kontu
    return unless @steam_user # Ja Steam konts nav piesaistīts, turpmākā koda izpilde tiek pārtraukta

    # Iegūst lietotāja spēles, sakārtotas pēc nospēlētā laika (dilstošā secībā)
    @steam_user_games = @steam_user.user_games.order(playtime_forever: :desc)

    # Steam profila pamatinformācija
    @steam_user_name = @steam_user.name
    @steam_user_level = @steam_user.user_level
    @steam_user_last_log_off = @steam_user.last_log_off
    @steam_user_country = @steam_user.loc_country_code
    @steam_user_time_created = @steam_user.time_created
    @steam_user_profile_image_url = @steam_user.profile_image_url

    # Papildu statistikas dati
    @games_owned = @steam_user.user_games.count
    @total_playtime_hours = @steam_user.user_games.total_playtime_hours
  end
end
