# == Schema Information
#
# Table name: ideas
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  priority   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Idea < ActiveRecord::Base
  attr_accessible :title, :priority, :pitch

  belongs_to :user, inverse_of: :ideas

  validates :title, length: {:in => 5..50, 
  			too_long: "must be fewer than 50 characters.",  
  			too_short: "must be at least 5 characters."}

  validates :pitch, length: {:in => 20..500,
  			too_long: "must be fewer than 500 characters.",
  			too_short: "must have at least 20 characters."}

  validates :user, presence: true

end
