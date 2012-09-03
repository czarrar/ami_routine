class CreateRoutineTemplates < ActiveRecord::Migration
  def change
    create_table :routine_templates do |t|
      t.references :sub_subject
      t.string :name
      t.text :description
      t.text :notes

      t.timestamps
    end
  end
end
