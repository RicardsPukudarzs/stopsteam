class UserGame < ApplicationRecord
  belongs_to :steam_user
end

# == Schema Information
#
# Table name: user_games
#
# id                :bigint           not null, primary key
# app_id            :integer
# name              :string
# playtime_forever  :integer
# img_icon_url      :string
# rtime_last_played :integer
# steam_user_id     :bigint           not null, foreign key
# created_at        :datetime         not null
# updated_at        :datetime         not null
