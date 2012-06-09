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
  belongs_to :role

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_id
  # attr_accessible :title, :body

  def get_available_rank_values

  	@ranks = self.ranks

  	@values = (1..10).collect{|i| i}

  	@ranks.each do |rank| 
  		@values.delete(rank.value)
    end

    return @values

  end

  def get_all_rank_slots

  	@output = Array.new
  	@ranks = self.ranks
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


  def get_rankings

  	@ranks = self.ranks

    @ranks.each do |rank|
      if rank.idea.status.category != "Rankable"
        @ranks.delete(rank)
      end
    end

  	@ranks = @ranks.sort_by! {|rank| rank.value}

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


  def nudge_rank_upward(rank_id)

    @rank = Rank.find_by_id(rank_id)

    @rank_above = self.ranks.find_by_value(@rank.value-1)

    @rank.transaction do
      if @rank_above.nil? == false then 
        #switch
        @rank.value -=1
        @rank_above.value +=1
        @rank.save
        @rank_above.save
      else
        @rank.value -=1
        @rank.save
      end
    end

  end


  def nudge_rank_downward(rank_id)
    @rank = Rank.find_by_id(rank_id)

    @rank_below = self.ranks.find_by_value(@rank.value+1)

    @rank.transaction do
      if @rank_below.nil? == false then 
        #switch
        @rank.value +=1
        @rank_below.value -=1
        @rank.save
        @rank_below.save
      else
        @rank.value +=1
        @rank.save
      end
    end  end

end


