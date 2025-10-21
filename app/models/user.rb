class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end

# == Schema Information
# Table name: users
# id         :bigint           not null, primary key
# username   :string           not null, unique
# email      :string           not null, unique
# password_digest :string      not null
# created_at :datetime         not null
# updated_at :datetime         not null
