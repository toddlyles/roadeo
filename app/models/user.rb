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

  	@ranks = self.ranks.joins(:idea).where('status in (select distinct status from idea where status in ("Active","Analysis","Ready"))')

  	@values = (1..10).collect{|i| i}

  	@ranks.each do |rank| 
  		@values.delete(rank.value)
    end

    return @values

  end

  def get_all_rank_slots

  	@output = Array.new

  	@ranks = self.ranks.joins(:idea).where('status in ("Active","Analysis","Ready")')
  	@ranks = @ranks.sort_by! {|rank| rank.value}

  	@values = (1..10).collect{|i| i}
  	@found = false

	@values.each do |i| 
		@ranks.each do |rank|
			if rank.value == i
				@output.push(rank)
				@found = true
			end
		end
		if @found == false
			@output.push(i)
		end
		@found = false
    end

    return @output

  end


  #def has_used_this_rank?(rank_value)
  	
  #	return @ranks = self.ranks.joins(:idea).where('status in ("Active","Analysis","Ready") and value = ?',rank_value).exists?

  #end


  #def get_rank(rank_value)
 
  #	return  self.ranks.includes(:idea).joins(:idea).where('status in ("Active","Analysis","Ready") and value = ?',rank_value)
 
  #end


  def get_rankings

  	@ranks = self.ranks.includes(:idea).joins(:idea).where('status in ("Active","Analysis","Ready")')
  	@ranks = @ranks.sort_by! {|rank| rank.value}

  	#return @ranks

  end


  def rank_idea(idea_to_vote_on_id, rank_value)
  	#basic voting method - changed to be an UPSERT

  	@idea = Idea.find_by_id(idea_to_vote_on_id)

  	@preexisting_rank = @idea.ranks.find_by_user_id(self.id)

  	#check to see if this user has already ranked--
  	if @preexisting_rank.nil?
  		@idea.ranks.create(user_id:self.id,value:rank_value) 
  	else
  		@preexisting_rank.value = rank_value
  		@preexisting_rank.save
  	end 

  end


  def nudge_rank_up(idea_to_nudge_id)
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
  				@unlucky_rank.value +=1
  			end

  			#save your work
  			#rank.transaction do
  				rank.save
  				if @switch_places
  					if @go_ahead_and_delete_it
  						@unlucky_rank.delete
  					else
  						@unlucky_rank.save
  					end
  				end
  			#end
  		end
  	end

  end

  def nudge_rank_down(idea_to_nudge_id)
  	#lowers the idea's rank with the user in question, pushing other item's lower, and potentially "losing" #10
  end

end


