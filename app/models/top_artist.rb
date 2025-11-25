class TopArtist < ApplicationRecord
  belongs_to :spotify_user
end

# == Schema Information
#
# Table name: top_artists
#
# id             :bigint           not null, primary key
# name           :string
# spotify_id     :string
# image_url      :string
# period         :string
# rank           :integer
# spotify_user_id :bigint          not null, foreign key
# created_at     :datetime         not null
# updated_at     :datetime         not null
#
