class Product < ApplicationRecord
  validates :model, :brand, presence: true

  belongs_to :brand


  def self.to_csv
    attributes = %w{name model brand}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |product|
        # csv << product.attributes.values_at(*attributes)
        row = []
        row << product.attributes.values_at("name")[0]
        row << product.attributes.values_at("model")[0]
        row << [Brand.find(product.brand_id).name][0]
        csv << row
      end

    end
  end
end
