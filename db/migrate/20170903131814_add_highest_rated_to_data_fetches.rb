class AddHighestRatedToDataFetches < ActiveRecord::Migration[5.0]
  def change
    add_column :data_fetches, :highest_rated, :string
  end
end
