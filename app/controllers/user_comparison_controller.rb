class UserComparisonController < ApplicationController
  before_action :require_logged_in

  def show
    user = User.find_by(id: params[:id])
    return redirect_to dashboard_path unless valid_comparison?(user)

    service = UserComparisonService.new

    @user1 = current_user
    @user2 = user
    @top_games_user1 = service.get_top_games(@user1, 10)
    @top_games_user2 = service.get_top_games(@user2, 10)
    @common_games = service.get_common_games(@user1, @user2)
    @top_artists_user1 = service.get_top_artists(@user1, 5)
    @top_artists_user2 = service.get_top_artists(@user2, 5)
    @common_artists = service.get_common_artists(@user1, @user2)
    @top_tracks_user1 = service.get_top_tracks(@user1, 10)
    @top_tracks_user2 = service.get_top_tracks(@user2, 10)
    @common_tracks = service.get_common_tracks(@user1, @user2)
    @music_compatibility_score = service.calculate_music_compatibility_score(@user1, @user2)
    @game_compatibility_score = service.calculate_game_compatibility_score(@user1, @user2)
  end

  private

  def valid_comparison?(user)
    return false if current_user.steam_user.nil? || current_user.spotify_user.nil?
    return false if user.nil?
    return false if user.steam_user.nil? || user.spotify_user.nil?
    return false if current_user.id == user.id

    true
  end
end
