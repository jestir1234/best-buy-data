class AddTopThreePercentageToBrands < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :top_three_percentage, :string
  end
end
