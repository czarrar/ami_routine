class CreateSubjectsChangeRoutines < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name

      t.timestamps
    end
    add_index(:subjects, :name, :unique => true)
    
    change_table :routines do |t|
      t.remove :title
      t.integer :subject_id
    end
  end
end
