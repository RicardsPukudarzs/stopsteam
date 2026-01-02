class UserComparisonController < ApplicationController
  # Nodrošina, ka meklēšanas funkcionalitātei var piekļūt tikai autentificēti lietotāji
  before_action :require_logged_in

  def show
    # Iegūst salīdzināmo lietotāju pēc identifikatora no pieprasījuma parametriem
    user = User.find_by(id: params[:id])

    # Pārbauda, vai lietotāju salīdzināšana ir korekta un atļauta
    # Nekorektā gadījumā lietotājs tiek pāradresēts uz galveno skatu
    return redirect_to dashboard_path unless valid_comparison?(user)

    # Inicializē servisu lietotāju datu salīdzināšanai
    service = UserComparisonService.new

    # Nosaka salīdzināmos lietotājus
    @user1 = current_user
    @user2 = user

    # Iegūst abu lietotāju visspēlētākās spēles
    @top_games_user1 = service.get_top_games(@user1, 10)
    @top_games_user2 = service.get_top_games(@user2, 10)

    # Iegūst kopīgās spēles starp abiem lietotājiem
    @common_games = service.get_common_games(@user1, @user2)

    # Iegūst abu lietotāju visklausītākos izpildītājus
    @top_artists_user1 = service.get_top_artists(@user1, 5)
    @top_artists_user2 = service.get_top_artists(@user2, 5)

    # Iegūst kopīgos izpildītājus starp abiem lietotājiem
    @common_artists = service.get_common_artists(@user1, @user2)

    # Iegūst abu lietotāju visklausītākās dziesmas
    @top_tracks_user1 = service.get_top_tracks(@user1, 10)
    @top_tracks_user2 = service.get_top_tracks(@user2, 10)

    # Iegūst kopīgās dziesmas starp abiem lietotājiem
    @common_tracks = service.get_common_tracks(@user1, @user2)

    # Aprēķina lietotāju saderības rādītājus balstoties uz mūzikas un spēļu datiem
    @music_compatibility_score = service.calculate_music_compatibility_score(@user1, @user2)
    @game_compatibility_score = service.calculate_game_compatibility_score(@user1, @user2)
  end

  private

  # Pārbauda, vai lietotāju salīdzināšana ir atļauta
  def valid_comparison?(user)
    # Pašreizējam lietotājam jābūt piesaistītiem gan Steam, gan Spotify kontiem
    return false if current_user.steam_user.nil? || current_user.spotify_user.nil?

    # Jāpastāv salīdzināmajam lietotājam
    return false if user.nil?

    # Salīdzināmajam lietotājam jābūt piesaistītiem gan Steam, gan Spotify kontiem
    return false if user.steam_user.nil? || user.spotify_user.nil?

    # Nav atļauta lietotāja salīdzināšana pašam ar sevi
    return false if current_user.id == user.id

    true
  end
end
