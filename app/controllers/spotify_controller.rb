class SpotifyController < ApplicationController
  # Nodrošina, ka meklēšanas funkcionalitātei var piekļūt tikai autentificēti lietotāji
  before_action :require_logged_in

  def spotify
    # Iegūst autorizācijas datus no OAuth autentifikācijas procesa
    auth = request.env['omniauth.auth']

    # Inicializē Spotify lietotāja objektu ar Rspotify ruby gem, izmantojot saņemtos autorizācijas datus
    spotify_user_data = RSpotify::User.new(auth)

    # Pārbauda, vai konkrētais Spotify konts jau nav piesaistīts citam sistēmas lietotājam
    if SpotifyUser.where(spotify_id: spotify_user_data.id).where.not(user_id: current_user.id).exists?

      # Informē lietotāju par piesaistes konfliktu, pāradresē lietotāju uz informācijas paneļa skatu un pārtrauc turpmāko izpildi
      flash[:alert] = 'This Spotify account is already linked to another user.'
      redirect_to dashboard_path
      return
    end

    # Inicializē servisu Spotify datu sinhronizācijai ar sistēmas datubāzi
    service = SpotifyService.new(auth, current_user)

    # Veic Spotify lietotāja datu iegūšanu un saglabāšanu sistēmā
    service.sync_user

    # Informē lietotāju par veiksmīgu Spotify konta piesaisti un pāradresē uz informācijas paneļa skatu
    flash[:notice] = 'Spotify account linked successfully.'
    redirect_to dashboard_path
  end
end
