require 'net/http'
require 'uri'

class Api::CollectionsController < ApplicationController

  def index
    page_content = Net::HTTP.get(URI.parse("https://www.bestbuy.com/site/searchpage.jsp?st=smart+tv&_dyncharset=UTF-8&id=pcat17071&type=page&sc=Global&cp=1&nrp=&sp=&qp=&list=n&af=true&iht=y&usc=All+Categories&ks=960&keys=keys"))
    document = Nokogiri::HTML(page_content)

    @brands = {
      "Samsung" => {
        result_count: 0,
        result_percentage: 0,
        },
      "LG" => {
        result_count: 0,
        result_percentage: 0,
        },
      "Toshiba" => {
        result_count: 0,
        result_percentage: 0,
        },
      "Sony" => {
        result_count: 0,
        result_percentage: 0,
        }
      }

    total_results = document.css("div.results-summary").text.split(" ")[7].to_i

    #percentage of brands / total results
    document.css("li.facet-value").each do |el|
      if @brands[el.get_attribute('data-value')]
        @brands[el.get_attribute('data-value')][:result_count] = el.get_attribute('data-count')
        @brands[el.get_attribute('data-value')][:result_percentage] = ((el.get_attribute('data-count').to_f / total_results) * 100).round(2).to_s + "%"
      end
    end

    #percentage of top 3 search results owned by each brand
    top = document.css("div.sku-title.h4.a")
    debugger

    render 'api/collections/show'
  end

end
