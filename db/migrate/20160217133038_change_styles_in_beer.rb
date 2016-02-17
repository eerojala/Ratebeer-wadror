class ChangeStylesInBeer < ActiveRecord::Migration
  def change
    add_column :beers, :style_id, :integer
    remove_column :beers, :style
  end
end
