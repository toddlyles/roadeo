# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :ideas
  has_many :ranks

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  def get_available_rank_values

  	# Each user is only allowed ranks 1-10 on the following Statuses: "Active", "Analysis", and "Ready"
  	# Once an item goes to Tabled, Working, or Finished I will need a way to clear ranks without losing history

  	# this works, but seems amazingly clunky to me.

  	@ranks = self.ranks.joins(:idea).where('status in ("Active","Analysis","Ready")')

  	@values = [1,2,3,4,5,6,7,8,9,10]

  	@ranks.each do |rank| 
  		@values.delete(rank.value)
    end

    return @values

  end

  def get_rankings

  	@ranks = self.ranks.includes(:idea).joins(:idea).where('status in ("Active","Analysis","Ready")')
  	@ranks = @ranks.sort_by! {|rank| rank.value}

  	return @ranks

  end


  def vote(idea_to_vote_on_id, rank_value)
  	#basic voting method

  	@idea = Idea.find_by_id(idea_to_vote_on_id)

  	@idea.ranks.create(user_id:self.id,value:rank_value) 

  end


  def nudge_up(idea_to_nudge_id)
  	#reduces the idea's rank with the user in question, switching places with anything ranked above it

  	@your_current_rankings = self.get_rankings
  	@switch_places = false

  	@your_current_rankings.each do |rank|
  		if rank.idea_id == idea_to_nudge_id
  		
  			#you've found it in the array--now is the slot above it occupied?
  			@your_current_rankings.each do |other_rank|
  				if rank.value-1 == other_rank.value
  					#uh-oh...the next rank is occupied...need to switch places
  					@switch_places = true
  					@unlucky_rank = other_rank
  				end
  			end

  			#elevate the rank
  			if rank.value != 1
	  			rank.value -= 1
	  		end

	  		#lower the poor bastard above it
  			if @switch_places
  				# NEED TO ADD A CHECK TO SEE IF IT REACHES 11
  				@unlucky_rank.value +=1
  			end

  			#save your work
  			rank.transaction do
  				rank.save
  				if @switch_places
  					@unlucky_rank.save
  				end
  			end

  		end
  	end

  end

  def nudge_down(idea_to_nudge_id)
  	#lowers the idea's rank with the user in question, pushing other item's lower, and potentially "losing" #10
  end

end


