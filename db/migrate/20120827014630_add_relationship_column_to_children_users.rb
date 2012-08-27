class AddRelationshipColumnToChildrenUsers < ActiveRecord::Migration
  def change
    add_column :children_users, :relationship, :string
  end
end
