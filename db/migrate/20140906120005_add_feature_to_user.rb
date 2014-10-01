class AddFeatureToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :avatar, :string
    add_column :users, :admin, :boolean, default: false
    add_column :users, :gender, :integer, default: 1
    add_column :users, :qq, :integer
    add_column :users, :city, :string
    add_column :users, :school, :integer, default: 1
    add_column :users, :description, :string
  end
end
