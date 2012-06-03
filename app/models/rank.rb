class Rank < ActiveRecord::Base
  attr_accessible :idea_id, :user_id, :value

  belongs_to :user 
  belongs_to :idea

  validates :idea_id, :presence => true
  validates :user_id, :presence => true
  validates :value, :numericality => {:less_than_or_equal_to => 10}


end
