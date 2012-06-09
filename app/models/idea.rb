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
  attr_accessible :title, :pitch, :status_id

  belongs_to :user, inverse_of: :ideas
  has_many :ranks

  #there isn't a single tutorial online that says it should work this way
  belongs_to :status

  validates :title, length: {:in => 5..100, 
  			too_long: "must be fewer than 100 characters.",  
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

# Idea Rank Calculations
def average_rank
  if total_rank_value !=0
    return total_rank_value/count_of_users_ranked
  else
    return 10
  end
end

def total_rank_value
  return self.ranks.select(:value).sum("value")
end


def count_of_users_ranked
  return self.ranks.select(:user_id).uniq.count("user_id")
end

#BAYESIAN AVERAGE

# BR = ((C*avg_rating) + (this_num_votes*this_rating))/(C+this_num_votes)

def bayesian_rank

  #this is an ad hoc value, which basically represents the minimum number of 
  #votes we think an Idea should have before it's even considered relevant.  
  #eventually this value will come from the admin screen
  @magic_number_of_votes = 0.5

  @return_value = ((@magic_number_of_votes*Idea.average_rank_of_all_ideas.to_f)+(self.count_of_users_ranked*self.average_rank.to_f))/(@magic_number_of_votes+self.count_of_users_ranked)

  if @return_value == 0
    return 10
  else
    return @return_value.round(2)
  end

end


#CLASS METHODS

def self.average_rank_of_all_ideas
  @sum = Idea.joins(:status).joins(:ranks).includes(:ranks).where(:statuses=>{:category=>'Rankable'}).sum(:value)
  @count = Idea.joins(:status).joins(:ranks).includes(:ranks).where(:statuses=>{:category=>'Rankable'}).count(:value)
  if @sum.to_i !=0 || @count.to_i !=0
    return @sum.to_i/@count.to_i
  else
    return 0
  end 
end



end
