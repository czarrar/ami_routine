class AddPublishedToRoutines < ActiveRecord::Migration
  def change
    add_column :routines, :published, :boolean
  end
end
