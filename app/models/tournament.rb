class Tournament < ActiveRecord::Base
  has_many :gamesets, dependent: :destroy
end
