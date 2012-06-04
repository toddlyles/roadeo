class AddIndexToRank < ActiveRecord::Migration
  def change
  	add_index :ranks, [:user_id, :idea_id]
  end
end
