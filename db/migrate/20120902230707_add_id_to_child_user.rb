class AddIdToChildUser < ActiveRecord::Migration
  def change
    add_column :child_users, :id, :primary_key
  end
end
