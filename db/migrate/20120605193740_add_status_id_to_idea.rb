class AddStatusIdToIdea < ActiveRecord::Migration
  def change
  	add_column :ideas, :status_id, :integer
  end
end
