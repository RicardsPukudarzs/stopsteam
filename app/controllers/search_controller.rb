class SearchController < ApplicationController
  def index
    query = params[:q].to_s.strip.downcase

    users = User.where('LOWER(username) LIKE ?', "%#{query}%").pluck(:id, :username)

    games = UserGame.where('LOWER(name) LIKE ?', "%#{query}%").distinct.pluck(:app_id, :name)

    render json: { users: users, games: games }
  end
end
