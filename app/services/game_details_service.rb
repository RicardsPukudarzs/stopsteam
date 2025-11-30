class GameDetailsService
  def initialize(game_details)
    @game_details = game_details
  end

  def name
    @game_details['name'] if @game_details
  end

  def short_description
    @game_details['short_description'] if @game_details
  end

  def header_image
    @game_details['header_image'] if @game_details
  end

  def price
    if @game_details && @game_details['price_overview'] && @game_details['price_overview']['final_formatted'].present?
      @game_details['price_overview']['final_formatted']
    else
      'Free'
    end
  end

  def categories
    return [] unless @game_details && @game_details['categories']

    @game_details['categories'].first(3).pluck('description')
  end

  def release_date
    @game_details.dig('release_date', 'date') if @game_details && @game_details['release_date']
  end

  def developers
    @game_details['developers'] if @game_details && @game_details['developers']
  end

  def publishers
    @game_details['publishers'] if @game_details && @game_details['publishers']
  end
end
