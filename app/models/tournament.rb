class Tournament < ActiveRecord::Base
  has_many :gamesets, dependent: :destroy
  has_and_belongs_to_many :players
  belongs_to :create_user, :class_name => 'User', :foreign_key => 'create_user_id'
  validates :url, :uniqueness => true, :allow_nil => true

end
