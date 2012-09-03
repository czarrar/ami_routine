class CreateSubSubjects < ActiveRecord::Migration
  def change
    create_table :sub_subjects do |t|
      t.string :name
      t.references :subject 
      
      t.timestamps
    end
  end
end
