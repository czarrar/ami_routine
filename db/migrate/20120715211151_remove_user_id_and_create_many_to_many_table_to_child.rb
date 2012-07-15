class RemoveUserIdAndCreateManyToManyTableToChild < ActiveRecord::Migration
  def change
    create_table(:children_users, :id => false) do |t|
      t.references :child
      t.references :user
    end
    
    add_index(:children_users, [ :child_id, :user_id ])
    
    change_table :children do |t|
      t.remove :user_id
    end
  end
end
