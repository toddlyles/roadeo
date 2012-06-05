class ChangeRankIndexToUnique < ActiveRecord::Migration
  def change
  	remove_index :ranks, [:user_id, :idea_id]
  	add_index :ranks, [:user_id, :idea_id], :unique => true
  end
end
