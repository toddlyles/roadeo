class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.integer :user_id
      t.integer :idea_id
      t.integer :value

      t.timestamps
    end
  end
end
