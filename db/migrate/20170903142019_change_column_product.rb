class ChangeColumnProduct < ActiveRecord::Migration[5.0]
  def change
    change_column :products, :model, :string
  end
end
