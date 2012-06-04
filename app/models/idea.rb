# == Schema Information
#
# Table name: ideas
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  user_id    :integer
#  pitch      :text
#  status     :text
#

class Idea < ActiveRecord::Base
  attr_accessible :title, :priority, :pitch, :status

  belongs_to :user, inverse_of: :ideas
  has_many :ranks

  validates :title, length: {:in => 5..50, 
  			too_long: "must be fewer than 50 characters.",  
  			too_short: "must be at least 5 characters."}

  validates :pitch, length: {:in => 20..500,
  			too_long: "must be fewer than 500 characters.",
  			too_short: "must have at least 20 characters."}

  validates :user, presence: true

  validates :status, presence: true



  def average_rank
  	
  	@ranks = self.ranks
  	@sum_of_ranks = 0

  	@ranks.each do |rank| 
  		@sum_of_ranks += rank.value
    end

  	return @sum_of_ranks/ranks.count

  end 


  #def current_user_has_ranked_already?(user_id)

  #	return Rank.joins(:idea).where(:user_id => user_id).exists?

  #end

end
