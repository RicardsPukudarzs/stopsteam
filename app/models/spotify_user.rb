class SpotifyUser < ApplicationRecord
  belongs_to :user
  has_many :top_artists, dependent: :destroy
  has_many :top_songs, dependent: :destroy
end

# == Schema Information
#
# Table name: spotify_users
#
# id                :bigint           not null, primary key
# display_name      :string
# profile_image_url :string
# user_id           :bigint           not null, unique, foreign key
# created_at        :datetime         not null
# updated_at        :datetime         not null
