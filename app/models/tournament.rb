class Tournament < ActiveRecord::Base
  has_many :gamesets, dependent: :destroy
  has_and_belongs_to_many :players
  validates :url, :uniqueness => true, :allow_nil => true
end
