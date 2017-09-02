require 'net/http'
require 'uri'

class Api::CollectionsController < ApplicationController

  def get_data
    query_string = params[:query].gsub(" ", "+")
    page_content = Net::HTTP.get(URI.parse("https://www.bestbuy.com/site/searchpage.jsp?st=#{query_string}&_dyncharset=UTF-8&id=pcat17071&type=page&sc=Global&cp=1&nrp=&sp=&qp=&list=n&af=true&iht=y&usc=All+Categories&ks=960&keys=keys"))
    document = Nokogiri::HTML(page_content)

    # @brands = {
    #   "Samsung" => {
    #     result_count: 0,
    #     result_percentage: 0,
    #     top_three: {
    #         count: 0,
    #         rank: {
    #           first: {
    #             count: 0,
    #             products: {
    #               total_review_count: 0
    #             }
    #           },
    #           second: {
    #             count: 0,
    #             products: {
    #               total_review_count: 0
    #             }
    #           },
    #           third: {
    #             count: 0,
    #             products: {
    #               total_review_count: 0
    #             }
    #           }
    #         }
    #       }
    #     },
    #   "LG" => {
    #     result_count: 0,
    #     result_percentage: 0,
    #     top_three: {
    #         count: 0,
    #         rank: {
    #           first: {
    #             count: 0,
    #             products: {
    #               total_review_count: 0
    #             }
    #           },
    #           second: {
    #             count: 0,
    #             products: {
    #               total_review_count: 0
    #             }
    #           },
    #           third: {
    #             count: 0,
    #             products: {
    #               total_review_count: 0
    #             }
    #           }
    #         }
    #       }
    #     },
    #   "Toshiba" => {
    #     result_count: 0,
    #     result_percentage: 0,
    #     top_three: {
    #         count: 0,
    #         rank: {
    #           first: {
    #             count: 0,
    #             products: {
    #               total_review_count: 0
    #             }
    #           },
    #           second: {
    #             count: 0,
    #             products: {
    #               total_review_count: 0
    #             }
    #           },
    #           third: {
    #             count: 0,
    #             products: {
    #               total_review_count: 0
    #             }
    #           }
    #         }
    #       }
    #     },
    #   "Sony" => {
    #     result_count: 0,
    #     result_percentage: 0,
    #     top_three: {
    #         count: 0,
    #         rank: {
    #           first: {
    #             count: 0,
    #             products: {
    #               total_review_count: 0
    #             }
    #           },
    #           second: {
    #             count: 0,
    #             products: {
    #               total_review_count: 0
    #             }
    #           },
    #           third: {
    #             count: 0,
    #             products: {
    #               total_review_count: 0
    #             }
    #           }
    #         }
    #       }
    #     }
    #   }

    

    @total_top_three_searched = 0 #fetch this number from db
    total_results = document.css("div.results-summary").text.split(" ")[7].to_i

    #percentage of brands / total results
    document.css("li.facet-value").each do |el|
      if @brands[el.get_attribute('data-value')]
        @brands[el.get_attribute('data-value')][:result_count] = el.get_attribute('data-count')
        @brands[el.get_attribute('data-value')][:result_percentage] = ((el.get_attribute('data-count').to_f / total_results) * 100).round(2).to_s + "%"
      end
    end

    #percentage of top 3 search results owned by each brand
    top_three = {};
    i = 0
    while i < 3
      brand = document.css("div.sku-title h4 a")[i].text.split(" ")[0]
      model = document.css("span.sku-value")[i].text
      reviews = document.css(".list-item-postcard span.number-of-reviews")[i].text.to_i
      rating = document.css(".list-item-postcard span .filled .sr-only")[i].text

      if (@brands[brand])
        @brands[brand][:top_three][:count] += 1
        if i == 0
          @brands[brand][:top_three][:rank][:first][:count] += 1
          @brands[brand][:top_three][:rank][:first][:products][model] ? nil : @brands[brand][:top_three][:rank][:first][:products][:total_review_count] += reviews
          @brands[brand][:top_three][:rank][:first][:products][model] = { reviews: reviews, rating: rating }
        elsif i == 1
          @brands[brand][:top_three][:rank][:second][:count] += 1
          @brands[brand][:top_three][:rank][:first][:products][model] ? nil : @brands[brand][:top_three][:rank][:first][:products][:total_review_count] += reviews
          @brands[brand][:top_three][:rank][:second][:products][model] = { reviews: reviews, rating: rating }
        elsif i == 2
          @brands[brand][:top_three][:rank][:third][:count] += 1
          @brands[brand][:top_three][:rank][:first][:products][model] ? nil : @brands[brand][:top_three][:rank][:first][:products][:total_review_count] += reviews
          @brands[brand][:top_three][:rank][:third][:products][model] = { reviews: reviews, rating: rating }
        end
      end
      i += 1
    end

    @total_top_three_searched += 1;

    render 'api/collections/show'
  end

  def initialize_brand_data(name)
      @brands[name] = {
        result_count: 0,
        result_percentage: 0,
        top_three: {
            count: 0,
            rank: {
              first: {
                count: 0,
                products: {
                  total_review_count: 0
                }
              },
              second: {
                count: 0,
                products: {
                  total_review_count: 0
                }
              },
              third: {
                count: 0,
                products: {
                  total_review_count: 0
                }
              }
            }
        }
  end

end
