class SteamUser < ApplicationRecord
  belongs_to :user
  has_many :user_game, dependent: :destroy
end

# == Schema Information
#
# Table name: steam_users
#
# id                :bigint           not null, primary key
# steam_id          :string
# name              :string
# profile_image_url :string
# profile_url       :string
# user_id           :bigint           not null, unique, foreign key
# created_at        :datetime         not null
# updated_at        :datetime         not null
