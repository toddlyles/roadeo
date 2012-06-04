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

  	# this works, but seems amazingly clunky to me.

  	@ranks = self.ranks.joins(:idea).where('status in ("Active","Analysis","Ready")')

  	@values = [1,2,3,4,5,6,7,8,9,10]

  	@ranks.each do |rank| 
  		@values.delete(rank.value)
    end

    return @values

  end

end


