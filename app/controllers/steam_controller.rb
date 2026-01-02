class SteamController < ApplicationController
  # Izslēdz CSRF aizsardzību konkrētajam Steam OAuth maršrutam,
  # jo autentifikācija tiek veikta, izmantojot trešās puses servisu
  skip_before_action :verify_authenticity_token, only: [:steam]

  # Nodrošina, ka Steam konta piesaistes funkcionalitāteivar piekļūt tikai autentificēti lietotāji
  before_action :require_logged_in

  def steam
    # Iegūst autorizācijas datus no Steam OAuth autentifikācijas procesa
    auth = request.env['omniauth.auth']
    steam_id = auth.uid

    # Pārbauda, vai konkrētais Steam konts jau nav piesaistīts citam sistēmas lietotājam
    if SteamUser.where(steam_id: steam_id).where.not(user_id: current_user.id).exists?
      # Informē lietotāju par piesaistes konfliktu un pārtrauc turpmāko izpildi un pāradresē lietotāju uz informācija paneļa skatu
      flash[:alert] = 'This Steam account is already linked to another user.'
      redirect_to dashboard_path
      return
    end

    # Inicializē servisu Steam datu sinhronizācijai ar sistēmas datubāzi
    service = SteamService.new
    service.sync_data(current_user, steam_id)

    # Informē lietotāju par veiksmīgu Steam konta piesaisti un to, ka spēļu statistika būs pieejama pēc dažām minūtēm
    flash[:notice] = 'Steam account linked. Game stats will be available in a few minutes.'
    # Pāradresē lietotāju uz informācijas paneli
    redirect_to dashboard_path
  end
end
