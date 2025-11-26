class User < ApplicationRecord
  has_secure_password

  has_one :spotify_user, dependent: :destroy
  has_one :steam_user, dependent: :destroy
end

# == Schema Information
#
# Table name: users
#
# id         :bigint           not null, primary key
# username   :string           not null, unique
# email      :string           not null, unique
# password_digest :string      not null
# created_at :datetime         not null
# updated_at :datetime         not null
