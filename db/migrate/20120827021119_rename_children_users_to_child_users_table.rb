class RenameChildrenUsersToChildUsersTable < ActiveRecord::Migration
  def change
    rename_table :children_users, :child_users
  end
end
