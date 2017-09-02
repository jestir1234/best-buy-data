class CreateBrands < ActiveRecord::Migration[5.0]
  def change
    create_table :brands do |t|
      t.string :name
      t.integer :result_count
      t.string :result_percentage
      t.json :top_three
      t.integer :top_three_count

      t.timestamps
    end
  end
end
