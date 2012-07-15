class AddTitleStartsEndsAllDayToRoutine < ActiveRecord::Migration
  def change
    add_column :routines, :title, :string
    add_column :routines, :starts_at, :datetime
    add_column :routines, :ends_at, :datetime
    add_column :routines, :all_day, :boolean
    rename_column :routines, :content, :description
    remove_column :routines, :routine_date
  end
end
