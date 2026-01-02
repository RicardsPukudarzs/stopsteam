class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  # Padara metodes pieejamas arī "views"
  helper_method :current_user, :logged_in?

  def current_user
    return @current_user if defined?(@current_user) # Atgriež pašreiz pieslēgušos lietotāju, ja tāds eksistē

    @current_user = User.find_by(id: session[:user_id]) # Atrod pašreiz pieslēgušos lietotāju pēc sesijas identifikatora
  end

  # Pārbauda vai lietotājs ir pieslēdzies
  def logged_in?
    current_user.present?
  end

  # Neļauj piekļūt lapām, kas paredzētas nepieslēgtiem lietotājiem
  # Ja lietotājs jau ir pieslēdzies, tiek pāradresēts uz informācijas paneli
  def require_logged_out
    redirect_to dashboard_path if logged_in?
  end

  # Nodrošina, ka konkrētai lapai var piekļūt tikai pieslēgti lietotāji
  # Ja lietotājs nav pieslēdzies, tiek pāradresēts uz pieteikšanās lapu
  def require_logged_in
    redirect_to login_path unless logged_in?
  end

  # Apstrādā gadījumus, kad pieprasītais maršruts netiek atrasts
  def route_not_found
    if logged_in?
      redirect_to dashboard_path # Pieslēgts lietotājs tiek pāradresēts uz dashboard
    else
      redirect_to login_path # nepieslēgts — uz pieteikšanās lapu
    end
  end
end
