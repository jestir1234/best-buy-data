class AddTopReviewedToDataFetches < ActiveRecord::Migration[5.0]
  def change
    add_column :data_fetches, :most_reviewed, :string
  end
end
