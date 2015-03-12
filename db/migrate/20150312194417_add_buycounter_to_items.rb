class AddBuycounterToItems < ActiveRecord::Migration
  def change
    add_column :items, :buycounter, :integer, :default => 0
    add_column :items, :first_bought_at, :timestamp, :default => :null
  end
end
