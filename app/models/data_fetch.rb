class DataFetch < ApplicationRecord

  def self.to_csv
    attributes = %w{date search_term top_three_results top_searched most_reviewed highest_rated}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |data|
        # csv << product.attributes.values_at(*attributes)
        row = []
        row << data.attributes.values_at("date")[0]
        row << data.attributes.values_at("search_term")[0]
        row << data.attributes.values_at("top_three_results")[0]
        row << data.attributes.values_at("top_searched_result")[0]
        row << data.attributes.values_at("most_reviewed")[0]
        row << data.attributes.values_at("highest_rated")[0]
        csv << row
      end

    end
  end

end
