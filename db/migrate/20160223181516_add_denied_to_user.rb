class AddDeniedToUser < ActiveRecord::Migration
  def change
    add_column :users, :denied, :boolean
  end
end
