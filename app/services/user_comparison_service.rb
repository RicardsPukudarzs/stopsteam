class UserComparisonService
  # Atgriež lietotāja populārākās spēles pēc kopējā spēlēšanas laika
  def get_top_games(user, limit = 10)
    user.steam_user.user_games.order(playtime_forever: :desc).limit(limit)
  end

  # Atrod kopīgās spēles diviem lietotājiem un aprēķina līdzības rādītājus
  def get_common_games(user1, user2)
    games1 = user1.steam_user.user_games
    games2 = user2.steam_user.user_games

    # Atrod kopīgos spēļu identifikatorus
    common_app_ids = games1.pluck(:app_id) & games2.pluck(:app_id)

    common_games = common_app_ids.map do |app_id|
      game1 = games1.find_by(app_id: app_id)
      game2 = games2.find_by(app_id: app_id)
      playtime1 = game1.playtime_hours
      playtime2 = game2.playtime_hours
      total_playtime = playtime1 + playtime2

      # Līdzības rādītājs – jo mazāka atšķirība, jo lielāka līdzība
      similarity = total_playtime - (playtime1 - playtime2).abs

      {
        app_id: app_id,
        name: game1.name,
        user1_playtime: playtime1,
        user2_playtime: playtime2,
        total_playtime: total_playtime,
        similarity: similarity
      }
    end

    # Sakārto spēles pēc līdzības un kopējā spēlēšanas laika
    common_games.sort_by { |g| [-g[:similarity], -g[:total_playtime]] }
  end

  # Atgriež lietotāja populārākos izpildītājus pēdējā gada periodā
  def get_top_artists(user, limit = 10)
    user.spotify_user.top_artists.where(period: 'last_year').order(:rank).limit(limit)
  end

  # Atrod kopīgos izpildītājus diviem lietotājiem
  def get_common_artists(user1, user2)
    artists1 = user1.spotify_user.top_artists.where(period: 'last_year').order(:rank)
    artists2 = user2.spotify_user.top_artists.where(period: 'last_year').order(:rank)

    artists1_hash = artists1.index_by(&:name)
    artists2_hash = artists2.index_by(&:name)

    common_names = artists1_hash.keys & artists2_hash.keys

    common_artists = common_names.map do |name|
      a1 = artists1_hash[name]
      a2 = artists2_hash[name]
      rank1 = a1.rank
      rank2 = a2.rank
      # Jo mazāks score, jo lielāka līdzība
      score = rank1 + rank2 + (rank1 - rank2).abs

      {
        name: name,
        image_url: a1.image_url || a2.image_url,
        user1_rank: rank1,
        user2_rank: rank2,
        score: score
      }
    end

    common_artists.sort_by { |a| a[:score] }
  end

  # Atgriež lietotāja populārākās dziesmas
  def get_top_tracks(user, limit = 10)
    user.spotify_user.top_songs.where(period: 'last_year').order(:rank).limit(limit)
  end

  # Atrod kopīgās dziesmas diviem lietotājiem
  def get_common_tracks(user1, user2)
    tracks1 = user1.spotify_user.top_songs.where(period: 'last_year').order(:rank)
    tracks2 = user2.spotify_user.top_songs.where(period: 'last_year').order(:rank)

    tracks1_hash = tracks1.index_by(&:name)
    tracks2_hash = tracks2.index_by(&:name)

    common_names = tracks1_hash.keys & tracks2_hash.keys

    common_tracks = common_names.map do |name|
      t1 = tracks1_hash[name]
      t2 = tracks2_hash[name]
      rank1 = t1.rank
      rank2 = t2.rank
      score = rank1 + rank2 + (rank1 - rank2).abs

      {
        name: name,
        image_url: t1.image_url || t2.image_url,
        artist_name: t1.artist_name || t2.artist_name,
        user1_rank: rank1,
        user2_rank: rank2,
        score: score
      }
    end

    common_tracks.sort_by { |t| t[:score] }
  end

  # Aprēķina kopējo mūzikas saderības koeficientu starp diviem lietotājiem
  def calculate_music_compatibility_score(user1, user2)
    artists1 = get_top_artists(user1, 10)
    artists2 = get_top_artists(user2, 10)
    artists1_hash = artists1.index_by(&:name)
    artists2_hash = artists2.index_by(&:name)

    tracks1 = get_top_tracks(user1, 10)
    tracks2 = get_top_tracks(user2, 10)
    tracks1_hash = tracks1.index_by(&:name)
    tracks2_hash = tracks2.index_by(&:name)

    # Izpildītāju pārklāšanās koeficients
    common_artists = artists1_hash.keys & artists2_hash.keys
    artist_overlap_score = common_artists.size / 10.0

    # Izpildītāju rangu līdzība
    artist_rank_score = if common_artists.any?
                          sum = common_artists.sum do |name|
                            r1 = artists1_hash[name].rank
                            r2 = artists2_hash[name].rank
                            1.0 - ((r1 - r2).abs / 10.0)
                          end
                          sum / common_artists.size
                        else
                          0.0
                        end

    # Dziesmu pārklāšanās koeficients
    common_tracks = tracks1_hash.keys & tracks2_hash.keys
    track_overlap_score = common_tracks.size / 10.0

    # Dziesmu rangu līdzība
    track_rank_score = if common_tracks.any?
                         sum = common_tracks.sum do |name|
                           r1 = tracks1_hash[name].rank
                           r2 = tracks2_hash[name].rank
                           1.0 - ((r1 - r2).abs / 10.0)
                         end
                         sum / common_tracks.size
                       else
                         0.0
                       end

    # Gala mūzikas saderības koeficients
    artist_score = (artist_overlap_score * 0.8) + (artist_rank_score * 0.2)
    track_score = (track_overlap_score * 0.8) + (track_rank_score * 0.2)

    total_score = (artist_score * 0.6) + (track_score * 0.4)
    total_score.round(3)
  end

  # Aprēķina spēļu saderības koeficientu starp diviem lietotājiem
  def calculate_game_compatibility_score(user1, user2)
    top_games1 = get_top_games(user1, 20)
    top_games2 = get_top_games(user2, 20)

    names1 = top_games1.map(&:name)
    names2 = top_games2.map(&:name)

    top_games1_hash = top_games1.index_by(&:name)
    top_games2_hash = top_games2.index_by(&:name)
    common_names10 = top_games1_hash.keys & top_games2_hash.keys

    # Spēlēšanas laika līdzības koeficients
    playtime_score = if common_names10.any?
                       sum = common_names10.sum do |name|
                         g1 = top_games1_hash[name]
                         g2 = top_games2_hash[name]
                         playtime1 = g1.playtime_hours
                         playtime2 = g2.playtime_hours
                         similarity = 1.0 - ((playtime1 - playtime2).abs / [playtime1, playtime2].max.to_f)
                         similarity.clamp(0, 1)
                       end
                       sum / common_names10.size
                     else
                       0.0
                     end

    # Kopīgo spēļu skaita koeficients
    common_names20 = names1 & names2
    common_games_score = common_names20.size / 20.0

    total_score = (playtime_score * 0.5) + (common_games_score * 0.5)
    total_score.round(3)
  end
end
