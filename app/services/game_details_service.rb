class GameDetailsService
  # Inicializē servisu ar spēles detalizēto informāciju, kas iegūta no Steam API
  def initialize(game_details)
    @game_details = game_details
  end

  # Atgriež spēles nosaukumu
  def name
    @game_details['name'] if @game_details
  end

  # Atgriež spēles īso aprakstu
  def short_description
    @game_details['short_description'] if @game_details
  end

  # Atgriež spēles galvenes attēla URL
  def header_image
    @game_details['header_image'] if @game_details
  end

  # Atgriež spēles cenu formatētā veidā ja cenas informācija nav pieejama, tiek pieņemts, ka spēle ir bezmaksas
  def price
    if @game_details && @game_details['price_overview'] && @game_details['price_overview']['final_formatted'].present?
      @game_details['price_overview']['final_formatted']
    else
      'Free'
    end
  end

  # Atgriež spēles kategorijas tiek atlasītas pirmās trīs kategorijas
  def categories
    return [] unless @game_details && @game_details['categories']

    @game_details['categories'].first(3).pluck('description')
  end

  # Atgriež spēles izdošanas datumu
  def release_date
    @game_details.dig('release_date', 'date') if @game_details && @game_details['release_date']
  end

  # Atgriež spēles izstrādātājus
  def developers
    @game_details['developers'] if @game_details && @game_details['developers']
  end

  # Atgriež spēles izdevējus
  def publishers
    @game_details['publishers'] if @game_details && @game_details['publishers']
  end
end
