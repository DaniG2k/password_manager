class Password < ApplicationRecord
  has_many :user_passwords, dependent: :destroy
  has_many :users, through: :user_passwords

  encrypts :username, deterministic: true
  encrypts :passsword

  validates(
    :url,
    :password,
    :username,
    presence: true
  )
end
