class DashboardsController < ApplicationController
  before_action :require_logged_in

  def index
    @spotify_user = current_user.spotify_user
    if @spotify_user
      @top_artists_last_year = @spotify_user.top_artists_by_period('last_year')
      @top_artists_last_6_months = @spotify_user.top_artists_by_period('6_months')
      @top_artists_last_4_weeks = @spotify_user.top_artists_by_period('4_weeks')
      @top_songs_last_year = @spotify_user.top_songs_by_period('last_year')
      @top_songs_last_6_months = @spotify_user.top_songs_by_period('6_months')
      @top_songs_last_4_weeks = @spotify_user.top_songs_by_period('4_weeks')
    end

    @steam_user = current_user.steam_user
    return unless @steam_user

    @steam_user_games = @steam_user.user_games.order(playtime_forever: :desc)
    @steam_user_name = @steam_user.name
    @steam_user_level = @steam_user.user_level
    @steam_user_last_log_off = @steam_user.last_log_off
    @steam_user_country = @steam_user.loc_country_code
    @steam_user_time_created = @steam_user.time_created
    @steam_user_profile_image_url = @steam_user.profile_image_url
    @games_owned = @steam_user.user_games.count
    @total_playtime_hours = @steam_user.user_games.total_playtime_hours
  end
end
