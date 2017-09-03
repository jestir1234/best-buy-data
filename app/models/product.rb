class Product < ApplicationRecord
  validates :model, :brand, presence: true

  belongs_to :brand
end
