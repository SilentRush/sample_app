class Player < ActiveRecord::Base
  has_and_belongs_to_many :tournaments
  has_and_belongs_to_many :gamesets
  has_and_belongs_to_many :gamematches
  validates :gamertag, :uniqueness => true
end