class CreateSelections < ActiveRecord::Migration
  def change
    create_table :selections do |t|
      t.string :status
      t.references :list, index: true
      t.references :item, index: true

      t.timestamps
    end
  end
end
