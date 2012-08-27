class ChangeIndexToChildrenUsers < ActiveRecord::Migration
  def up
    remove_index :children_users, [ :child_id, :user_id ]
    add_index :children_users, [ :child_id, :user_id ], :unique => true
  end

  def down
    remove_index :children_users, [ :child_id, :user_id ]
    add_index :children_users, [ :child_id, :user_id ]
  end
end
