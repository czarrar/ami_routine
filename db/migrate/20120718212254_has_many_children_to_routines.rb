class HasManyChildrenToRoutines < ActiveRecord::Migration
  def change
    create_table(:children_routines, :id => false) do |t|
      t.references :child
      t.references :routine
    end
    add_index(:children_routines, [ :child_id, :routine_id ], :unique => true)
    
    change_table :routines do |t|
      t.remove :child_id
    end
  end
end
