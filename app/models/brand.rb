class Brand < ApplicationRecord
  validates :name, presence: true

  has_many :products,
  primary_key: :id,
  foreign_key: :product_id,
  class_name: "Products"

end
