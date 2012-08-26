class CreateRoutineReadings < ActiveRecord::Migration
  def change
    create_table :routine_readings do |t|
      t.integer :routine_id
      t.integer :user_id
      t.integer :count, :default => 0

      t.timestamps
    end
    
    add_index(:routine_readings, [:routine_id, :user_id], :unique => true)
  end
end
