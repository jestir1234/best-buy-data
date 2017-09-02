class CreateDataFetches < ActiveRecord::Migration[5.0]
  def change
    create_table :data_fetches do |t|
      t.date :date
      t.string :search_term

      t.timestamps
    end
  end
end
