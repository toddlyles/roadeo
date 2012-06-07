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
  attr_accessible :title, :priority, :pitch

  belongs_to :user, inverse_of: :ideas
  has_many :ranks
  belongs_to :status

  validates :title, length: {:in => 5..50, 
  			too_long: "must be fewer than 50 characters.",  
  			too_short: "must be at least 5 characters."}

  validates :pitch, length: {:in => 20..500,
  			too_long: "must be fewer than 500 characters.",
  			too_short: "must have at least 20 characters."}

  validates :user, presence: true


  def average_rank

    # The average Rank this Idea has received
  	
  	@ranks = self.ranks
  	@sum_of_ranks = 0

  	@ranks.each do |rank| 
  		@sum_of_ranks += rank.value
    end

    if ranks.count != 0
		return @sum_of_ranks/ranks.count
	else
		return 10
	end 
  end 

  def standing

    # Get all ideas...ugh this seems tedious
    @ideas = Idea.all

    # Only look at rankable ideas
    @ideas.each do |idea|
      if idea.status.category != "Rankable"
        @ideas.delete(idea)
      end
    end

    @ideas.sort! {|a,b| a.average_rank <=> b.average_rank}


  end



  #def current_user_has_ranked_already?(user_id)

  #	return Rank.joins(:idea).where(:user_id => user_id).exists?

  #end

end
