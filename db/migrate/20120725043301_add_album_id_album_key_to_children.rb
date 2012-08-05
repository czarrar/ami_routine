class AddAlbumIdAlbumKeyToChildren < ActiveRecord::Migration
  def change
    add_column :children, :album_id, :integer
    add_column :children, :album_key, :string
  end
end
