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
  attr_accessible :title, :priority

  belongs_to :user, inverse_of: :ideas

  validates :title, presence: true
  validates :user, presence: true
end
