class AddTopSearchedResultToDataFetches < ActiveRecord::Migration[5.0]
  def change
    add_column :data_fetches, :top_searched_result, :string
  end
end
