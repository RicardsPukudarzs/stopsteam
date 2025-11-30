class DashboardsController < ApplicationController
  before_action :require_logged_in

  def index
    if current_user.spotify_user
      @top_artists_all_time = current_user.spotify_user.top_artists_by_period('all_time')
      @top_artists_last_6_months = current_user.spotify_user.top_artists_by_period('6_months')
      @top_artists_last_4_weeks = current_user.spotify_user.top_artists_by_period('4_weeks')
      @top_songs_all_time = current_user.spotify_user.top_songs_by_period('all_time')
      @top_songs_last_6_months = current_user.spotify_user.top_songs_by_period('6_months')
      @top_songs_last_4_weeks = current_user.spotify_user.top_songs_by_period('4_weeks')
    end

    return unless current_user.steam_user

    @steam_user_games = current_user.steam_user.user_games.order(playtime_forever: :desc)
  end
end
