class SearchController < ApplicationController
  before_action :require_logged_in

  def index
    query = params[:q].to_s.strip.downcase

    users = current_user.steam_user && current_user.spotify_user ? search_users(query) : []
    games = search_games(query)

    render json: { users: users, games: games }
  end

  private

  def search_users(query)
    User
      .joins(:spotify_user, :steam_user)
      .where('LOWER(username) LIKE ?', "%#{query}%")
      .where.not(id: current_user.id)
      .pluck(:id, :username)
  end

  def search_games(query)
    UserGame.where('LOWER(name) LIKE ?', "%#{query}%").distinct.pluck(:app_id, :name)
  end
end
