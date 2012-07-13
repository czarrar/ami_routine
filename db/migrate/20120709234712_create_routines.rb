class CreateRoutines < ActiveRecord::Migration
  def change
    create_table :routines do |t|
      t.integer :user_id    # teacher
      t.integer :child_id
      t.text :content
      t.date :routine_date
      t.timestamps
    end
    
    create_table :children do |t|
      t.integer :user_id    # parent
      t.string :first_name
      t.string :last_name
      t.timestamps
    end
  end
end
