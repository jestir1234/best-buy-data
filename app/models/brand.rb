class Brand < ApplicationRecord
  validates :name, presence: true

  has_many :products,
  primary_key: :id,
  foreign_key: :product_id,
  class_name: "Products"


  def self.to_csv
    attributes = %w{name result_count result_percentage top_three_count top_three_percentage}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |brand|
        # csv << product.attributes.values_at(*attributes)
        row = []
        row << brand.attributes.values_at("name")[0]
        row << brand.attributes.values_at("result_count")[0]
        row << brand.attributes.values_at("result_percentage")[0]
        row << brand.attributes.values_at("top_three_count")[0]
        row << brand.attributes.values_at("top_three_percentage")[0]
        csv << row
      end

    end
  end

end
