class AddTopThreeResultsToDataFetches < ActiveRecord::Migration[5.0]
  def change
    add_column :data_fetches, :top_three_results, :string
  end
end
