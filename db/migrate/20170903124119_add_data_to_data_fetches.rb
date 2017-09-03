class AddDataToDataFetches < ActiveRecord::Migration[5.0]
  def change
    add_column :data_fetches, :data, :json
  end
end
