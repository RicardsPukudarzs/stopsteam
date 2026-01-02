class SessionsController < ApplicationController
  # Nodrošina, ka pieteikšanās funkcionalitātei var piekļūt tikai neautentificēti lietotāji
  before_action :require_logged_out, only: %i[new create]

  # Attēlo lietotāja pieteikšanās formu
  def new; end

  def create
    # Iegūst lietotāja ievadītos autentifikācijas datus no pieprasījuma parametriem
    email = params[:user][:email]
    password = params[:user][:password]

    # Pārbauda, vai obligātie lauki nav tukši
    if email.blank? || password.blank?
      redirect_to login_path, alert: 'Email and password cannot be blank.'
      return
    end

    # Meklē lietotāju datubāzē pēc norādītās e-pasta adreses
    user = User.find_by(email: email)

    # Veic lietotāja autentifikāciju, izmantojot drošu paroles pārbaudes mehānismu
    if user&.authenticate(password)

      # Saglabā lietotāja identifikatoru sesijā,
      # nodrošinot autorizētu piekļuvi sistēmas funkcionalitātei
      session[:user_id] = user.id

      # Pāradresē lietotāju uz informācijas paneļa skatu ar paziņojumu.
      redirect_to dashboard_path, notice: 'Logged in successfully.'
    else
      # Neveiksmīgas autentifikācijas gadījumā lietotājs tiek informēts par kļūdu
      redirect_to login_path, alert: 'Wrong email or password.'
    end
  end

  def destroy
    # Dzēš lietotāja sesijas informāciju,
    # tādējādi pārtraucot autorizēto piekļuvi sistēmai
    session[:user_id] = nil

    # Pāradresē lietotāju uz sākumlapu pēc veiksmīgas atteikšanās
    redirect_to root_path, notice: 'Logged out successfully.'
  end
end
