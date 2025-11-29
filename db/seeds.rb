# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create users
users = [
  { username: 'alice', email: 'alice@example.com', password: 'password' },
  { username: 'bob', email: 'bob@example.com', password: 'password' },
  { username: 'carol', email: 'carol@example.com', password: 'password' },
  { username: 'dave', email: 'dave@example.com', password: 'password' }
].map { |attrs| User.create!(attrs) }

# Create Steam and Spotify connections
steam_users = [
  { steam_id: '76561198000000001', name: 'AliceSteam', profile_image_url: '', profile_url: '', user: users[0], user_level: 10 },
  { steam_id: '76561198000000002', name: 'BobSteam', profile_image_url: '', profile_url: '', user: users[1], user_level: 15 },
  { steam_id: '76561198000000003', name: 'CarolSteam', profile_image_url: '', profile_url: '', user: users[2], user_level: 20 },
  { steam_id: '76561198000000004', name: 'DaveSteam', profile_image_url: '', profile_url: '', user: users[3], user_level: 25 }
].map { |attrs| SteamUser.create!(attrs) }

spotify_users = [
  { display_name: 'AliceSpotify', profile_image_url: '', user: users[0] },
  { display_name: 'BobSpotify', profile_image_url: '', user: users[1] },
  { display_name: 'CarolSpotify', profile_image_url: '', user: users[2] },
  { display_name: 'DaveSpotify', profile_image_url: '', user: users[3] }
].map { |attrs| SpotifyUser.create!(attrs) }

# Create games for each user
games_data = [
  { app_id: 570, name: 'Dota 2', playtime_forever: 1200, img_icon_url: 'dota2icon', rtime_last_played: Time.now.to_i },
  { app_id: 730, name: 'Counter-Strike 2', playtime_forever: 78_000, img_icon_url: 'csgoicon', rtime_last_played: Time.now.to_i - 86_400 },
  { app_id: 440, name: 'Team Fortress 2', playtime_forever: 300, img_icon_url: 'tf2icon', rtime_last_played: Time.now.to_i - 172_800 }
]

steam_users.each_with_index do |steam_user, i|
  games_data.each_with_index do |game, j|
    UserGame.create!(
      app_id: game[:app_id],
      name: game[:name],
      playtime_forever: game[:playtime_forever] + (i * 100) + (j * 50),
      img_icon_url: game[:img_icon_url],
      rtime_last_played: game[:rtime_last_played] - (i * 3600),
      steam_user: steam_user
    )
  end
end

# Create top artists for each Spotify user
artists_data = [
  { name: 'Taylor Swift', spotify_id: '1', image_url: 'https://i.scdn.co/image/ab6761610000e5ebe2e8e7ff002a4afda1c7147e', period: 'all_time', rank: 1 },
  { name: 'Drake', spotify_id: '2', image_url: 'https://i.scdn.co/image/ab6761610000e5eb4293385d324db8558179afd9', period: 'all_time', rank: 2 },
  { name: 'Billie Eilish', spotify_id: '3', image_url: 'https://i.scdn.co/image/ab6761610000e5eb4a21b4760d2ecb7b0dcdc8da', period: 'all_time', rank: 3 },
  { name: 'The Weeknd', spotify_id: '4', image_url: 'https://i.scdn.co/image/ab6761610000e5eb9e528993a2820267b97f6aae', period: 'all_time', rank: 4 },
  { name: 'Bladee', spotify_id: '5', image_url: 'https://i.scdn.co/image/ab6761610000e5eb43633ee607e147dfd024a198', period: 'all_time', rank: 5 },
  { name: 'Ecco2k', spotify_id: '6', image_url: 'https://i.scdn.co/image/ab6761610000e5eba4caf4073b40cef9206c8012', period: 'all_time', rank: 6 },
  { name: 'Sewerslvt', spotify_id: '7', image_url: 'https://i.scdn.co/image/ab6761610000e5eb8a1271f7f32e5202924ebff2', period: 'all_time', rank: 7 }
]

spotify_users.each_with_index do |spotify_user, i|
  artists_data.each_with_index do |artist, j|
    TopArtist.create!(
      name: artist[:name],
      spotify_id: artist[:spotify_id],
      image_url: artist[:image_url],
      period: artist[:period],
      rank: j + 1,
      spotify_user: spotify_user
    )
  end
end

# Create top tracks for each Spotify user
tracks_data = [
  { name: 'Anti-Hero', album_name: 'Midnights', spotify_id: 't1', image_url: '', period: 'all_time', rank: 1, artist_name: 'Taylor Swift' },
  { name: 'God\'s Plan', album_name: 'Scorpion', spotify_id: 't2', image_url: '', period: 'all_time', rank: 2, artist_name: 'Drake' },
  { name: 'bad guy', album_name: 'WHEN WE ALL FALL ASLEEP, WHERE DO WE GO?', spotify_id: 't3', image_url: '', period: 'all_time', rank: 3,
    artist_name: 'Billie Eilish' },
  { name: 'Blinding Lights', album_name: 'After Hours', spotify_id: 't4', image_url: '', period: 'all_time', rank: 4, artist_name: 'The Weeknd' },
  { name: 'huh', album_name: 'i care so much that i dont care at all', spotify_id: 't5', image_url: '', period: 'all_time', rank: 5, artist_name: 'glaive' },
  { name: 'Hopelessness', album_name: 'Draining Love Story', spotify_id: 't6', image_url: '', period: 'all_time', rank: 6, artist_name: 'Sewerslvt' },
  { name: 'Sneg', album_name: 'sneg - Single', spotify_id: 't7', image_url: '', period: 'all_time', rank: 7, artist_name: 'nomark' },
  { name: 'Freudian', album_name: 'i care so much that i dont care at all', spotify_id: 't8', image_url: '', period: 'all_time', rank: 8,
    artist_name: 'glaive' },
  { name: 'Vordhosbn', album_name: 'Drukqs', spotify_id: 't9', image_url: '', period: 'all_time', rank: 9, artist_name: 'Aphex Twin' },
  { name: 'Restlessness', album_name: 'Draining Love Story', spotify_id: 't10', image_url: '', period: 'all_time', rank: 10, artist_name: 'Sewerslvt' }
]

spotify_users.each_with_index do |spotify_user, i|
  tracks_data.each_with_index do |track, j|
    TopSong.create!(
      name: track[:name],
      album_name: track[:album_name],
      spotify_id: track[:spotify_id],
      image_url: track[:image_url],
      period: track[:period],
      rank: j + 1,
      artist_name: track[:artist_name],
      spotify_user: spotify_user
    )
  end
end
