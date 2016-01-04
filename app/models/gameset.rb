class Gameset < ActiveRecord::Base
  belongs_to :tournament
  has_many :gamematches, dependent: :destroy
end
