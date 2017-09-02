class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :model
      t.integer :brand_id

      t.timestamps
    end
  end
end
