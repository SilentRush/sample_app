class Player < ActiveRecord::Base
  has_and_belongs_to_many :tournaments
  has_and_belongs_to_many :gamesets
  has_and_belongs_to_many :gamematches
  belongs_to :create_user, :class_name => 'User', :foreign_key => 'create_user_id'
  validates :gamertag, :uniqueness => true, allow_blank: false

  def self.search(search)
    where("gamertag LIKE ?", "#{search}")
  end
end
