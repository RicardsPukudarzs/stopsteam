class UserComparisonController < ApplicationController
  before_action :require_logged_in
  def show
    return redirect_to dashboard_path if current_user.steam_user.nil? || current_user.spotify_user.nil?
    return redirect_to dashboard_path if User.find(params[:id]).steam_user.nil? || User.find(params[:id]).spotify_user.nil?

    @user1 = current_user
    @user2 = User.find(params[:id])
    @top_games_user1 = get_top_games(@user1, 10)
    @top_games_user2 = get_top_games(@user2, 10)
    @common_games = get_common_games(@user1, @user2)
    @top_artists_user1 = get_top_artists(@user1, 5)
    @top_artists_user2 = get_top_artists(@user2, 5)
    @common_artists = get_common_artists(@user1, @user2)
    @top_tracks_user1 = get_top_tracks(@user1, 10)
    @top_tracks_user2 = get_top_tracks(@user2, 10)
    @common_tracks = get_common_tracks(@user1, @user2)
    @music_compatibility_score = calculate_music_compatibility_score(@user1, @user2)
    @game_compatibility_score = calculate_game_compatibility_score(@user1, @user2)
  end

  private

  def get_top_games(user, limit = 10)
    user.steam_user.user_games.order(playtime_forever: :desc).limit(limit)
  end

  def get_common_games(user1, user2)
    games1 = user1.steam_user.user_games
    games2 = user2.steam_user.user_games

    common_app_ids = games1.pluck(:app_id) & games2.pluck(:app_id)

    common_games = common_app_ids.map do |app_id|
      game1 = games1.find_by(app_id: app_id)
      game2 = games2.find_by(app_id: app_id)
      playtime1 = game1.playtime_hours
      playtime2 = game2.playtime_hours
      total_playtime = playtime1 + playtime2

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

    common_games.sort_by { |g| [-g[:similarity], -g[:total_playtime]] }
  end

  def get_top_artists(user, limit = 10)
    user.spotify_user.top_artists.where(period: 'all_time').order(:rank).limit(limit)
  end

  def get_common_artists(user1, user2)
    artists1 = user1.spotify_user.top_artists.where(period: 'all_time').order(:rank)
    artists2 = user2.spotify_user.top_artists.where(period: 'all_time').order(:rank)

    artists1_hash = artists1.index_by(&:name)
    artists2_hash = artists2.index_by(&:name)

    common_names = artists1_hash.keys & artists2_hash.keys

    common_artists = common_names.map do |name|
      a1 = artists1_hash[name]
      a2 = artists2_hash[name]
      rank1 = a1.rank
      rank2 = a2.rank
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

  def get_top_tracks(user, limit = 10)
    user.spotify_user.top_songs.where(period: 'all_time').order(:rank).limit(limit)
  end

  def get_common_tracks(user1, user2)
    tracks1 = user1.spotify_user.top_songs.where(period: 'all_time').order(:rank)
    tracks2 = user2.spotify_user.top_songs.where(period: 'all_time').order(:rank)

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

  def calculate_music_compatibility_score(user1, user2)
    artists1 = get_top_artists(user1, 50)
    artists2 = get_top_artists(user2, 50)
    names1 = artists1.map(&:name)
    names2 = artists2.map(&:name)

    tracks1 = get_top_tracks(user1, 50)
    tracks2 = get_top_tracks(user2, 50)
    track_names1 = tracks1.map(&:name)
    track_names2 = tracks2.map(&:name)

    if names1 == names2
      artist_score = 1.0
    else
      common_artists = names1 & names2
      sum = common_artists.sum do |name|
        r1 = names1.index(name)
        r2 = names2.index(name)
        1.0 - ((r1 - r2).abs / 10.0) - ((r1 + r2) / 20.0)
      end
      artist_score = sum / 10.0
      artist_score = artist_score.clamp(0, 1)
    end

    if track_names1 == track_names2
      track_score = 1.0
    else
      common_tracks = track_names1 & track_names2
      sum = common_tracks.sum do |name|
        r1 = track_names1.index(name)
        r2 = track_names2.index(name)
        1.0 - ((r1 - r2).abs / 10.0) - ((r1 + r2) / 20.0)
      end
      track_score = sum / 10.0
      track_score = track_score.clamp(0, 1)
    end

    ((artist_score * 0.5) + (track_score * 0.5)).round(3)
  end

  def calculate_game_compatibility_score(user1, user2)
    top_games1 = get_top_games(user1, 10)
    top_games2 = get_top_games(user2, 10)

    names1 = top_games1.map(&:name)
    names2 = top_games2.map(&:name)

    return 1.0 if names1 == names2

    common_names = names1 & names2

    sum = common_names.sum do |name|
      r1 = names1.index(name)
      r2 = names2.index(name)
      g1 = top_games1[r1]
      g2 = top_games2[r2]
      playtime1 = g1.playtime_hours
      playtime2 = g2.playtime_hours

      playtime_similarity = 1.0 - ((playtime1 - playtime2).abs / [playtime1, playtime2].max.to_f)
      playtime_similarity = playtime_similarity.clamp(0, 1)

      rank_similarity = 1.0 - ((r1 - r2).abs / 10.0) - ((r1 + r2) / 20.0)
      rank_similarity = rank_similarity.clamp(0, 1)

      (rank_similarity * 0.5) + (playtime_similarity * 0.5)
    end

    score = sum / 10.0
    score.clamp(0, 1).round(3)
  end
end
