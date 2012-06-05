class PopulateStatusTable < ActiveRecord::Migration
  
  def change
  	Status.create :name => "Active", :category => "Rankable"
  	Status.create :name => "Analysis", :category => "Rankable"
  	Status.create :name => "Ready", :category => "Rankable"
  	Status.create :name => "Working", :category => "Unrankable"
  	Status.create :name => "Tabled", :category => "Unrankable"
  	Status.create :name => "Finished", :category => "Unrankable"
  end

end
