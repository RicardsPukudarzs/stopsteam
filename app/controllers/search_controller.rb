class SearchController < ApplicationController
  before_action :require_logged_in

  def index
    query = params[:q].to_s.strip.downcase

    # Only show users if current user has both connections
    users = if current_user&.spotify_user && current_user.steam_user
              User
                .joins(:spotify_user, :steam_user)
                .where('LOWER(username) LIKE ?', "%#{query}%")
                .pluck(:id, :username)
            else
              []
            end

    games = UserGame.where('LOWER(name) LIKE ?', "%#{query}%").distinct.pluck(:app_id, :name)

    render json: { users: users, games: games }
  end
end
