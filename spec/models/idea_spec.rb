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

require 'spec_helper'

describe Idea do
  pending "add some examples to (or delete) #{__FILE__}"
end
