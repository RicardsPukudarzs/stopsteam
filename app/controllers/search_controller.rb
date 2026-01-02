class SearchController < ApplicationController
  # Nodrošina, ka meklēšanas funkcionalitātei var piekļūt tikai autentificēti lietotāji
  before_action :require_logged_in

  def index
    # Iegūst lietotāja ievadīto meklēšanas vaicājumu no pieprasījuma parametriem
    # Noņem liekās atstarpes un normalizē to salīdzināšanai
    query = params[:q].to_s.strip.downcase

    # Lietotāju meklēšana tiek veikta tikai gadījumā, ja pašreizējam lietotājam ir piesaistīti gan Steam, gan Spotify konti
    users = current_user.steam_user && current_user.spotify_user ? search_users(query) : []

    # Veic spēļu meklēšanu pēc nosaukuma
    games = search_games(query)

    Atgriež meklēšanas rezultātus JSON formātā
    render json: { users: users, games: games }
  end

  private

  # Veic lietotāju meklēšanu tikai starp lietotājiem kam ir piesaistīti gan Steam, gan Spotify konti
  # No rezultāttiem tiek izslēgts pašreizējais lietotājs
  def search_users(query)
    User
      .joins(:spotify_user, :steam_user)
      .where('LOWER(username) LIKE ?', "%#{query}%")
      .where.not(id: current_user.id)
      .pluck(:id, :username)
  end

  # Veic spēļu meklēšanu pēc nosaukuma lietotāju spēļu datos
  # Tiek atgrieztas unikālas spēles, identificētas pēc app_id
  def search_games(query)
    UserGame.where('LOWER(name) LIKE ?', "%#{query}%").distinct.pluck(:app_id, :name)
  end
end
