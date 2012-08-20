class AddAddressAndPhoneFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone_home, :string
    add_column :users, :phone_work, :string
    add_column :users, :phone_mobile, :string
    add_column :users, :address_home, :string
    add_column :users, :city_home, :string
    add_column :users, :zip_home, :string
    add_column :users, :notes, :text
  end
end
