require 'net/http'
require 'uri'


class Api::CollectionsController < ApplicationController

  INTERESTED_BRANDS = ["Samsung", "LG", "Toshiba", "Sony"]


  def index

  end

  def get_data
    # Use query string from API URL to interpolate the search term into bestbuy's search URL
    # Fetch HTML with Nokogiri library
    query_string = params[:query].gsub(" ", "+")
    page_content = Net::HTTP.get(URI.parse("https://www.bestbuy.com/site/searchpage.jsp?st=#{query_string}&_dyncharset=UTF-8&id=pcat17071&type=page&sc=Global&cp=1&nrp=&sp=&qp=&list=n&af=true&iht=y&usc=All+Categories&ks=960&keys=keys"))
    document = Nokogiri::HTML(page_content)

    # Initiate brands data if none exist OR fetch most recent brands data from previous data collection
    initialize_data

    # Parse HTML and identify brands of interest before collecting the search results number
    # from the current data collection and incrementing the running total
    update_search_results(document)

    # Percentage of top 3 search results owned by each brand
    # Review and Rating data collection
    # Increment running total for top three
    @brands["total_top_three_searched"] += 3;
    current_top_three_results = []
    top_searched = ""
    most_reviewed_num = 0
    most_reviewed_brand = ""
    highest_rated_num = 0
    highest_rated_brand = ""
    highest_rated_text = ""

    i = 0
    while i < 3
      # Parse through top three results to find brand, model, reviews, and ratings
      brand = document.css("div.sku-title h4 a")[i].text.split(" ")[0]
      name = document.css("div.sku-title h4 a")[i].text
      model = document.css("span.sku-value")[i].text
      reviews = document.css(".list-item-postcard span.number-of-reviews")[i].text.to_i
      rating = document.css(".list-item-postcard span .filled .sr-only")[i].text
      rating_num = document.css(".list-item-postcard span .filled .sr-only")[i].text.split("")[0].to_f

      # save relevant results to post to database later
      current_top_three_results << brand
      top_searched = brand if i == 0
      if reviews > most_reviewed_num
        most_reviewed_num = reviews
        most_reviewed_brand = brand
      end

      if rating_num > highest_rated_num
        highest_rated_num = rating_num
        highest_rated_brand = brand
        highest_rated_text = rating
      end

      ranking = { "0" => "first", "1" => "second", "2" => "third" }
      # Identify whether brand is of interest and at which ranking (1 - 3)
      # Save to brands hash and increment counts
      if (@brands[brand])
        @brands[brand]["top_three"]["count"] += 1
        @brands[brand]["top_three_percentage"] = ((@brands[brand]["top_three"]["count"].to_f / @brands["total_top_three_searched"]) * 100).round(2).to_s + "%"
        @brands[brand]["top_three"]["rank"][ranking[i.to_s]]["count"] += 1
        if !@brands[brand]["top_three"]["rank"][ranking[i.to_s]]["products"][model]
           @brands[brand]["top_three"]["rank"][ranking[i.to_s]]["products"]["total_review_count"] += reviews
           create_new_product(name, model, brand)
        end
        @brands[brand]["top_three"]["rank"]["first"]["products"][model] = { reviews: reviews, rating: rating }
      end
      i += 1

    end

    # Update database with the data received from current collection
    INTERESTED_BRANDS.each { |brand| update_brand_info(brand) }

    #Insert new collection into DataFetch table
    most_reviewed = "#{most_reviewed_brand} with #{most_reviewed_num} reviews"
    highest_rated = "#{highest_rated_brand} with #{highest_rated_text}"
    insert_new_data(query_string, current_top_three_results, top_searched, most_reviewed, highest_rated)

    render json: @brands
  end

  def initialize_data
    if DataFetch.all.length == 0
      @brands = { "total_top_three_searched" => 0, "total_results" => 0 }
      INTERESTED_BRANDS.each { |brand| initialize_brand_data(brand) }
    else
      @brands = DataFetch.last.data
    end
  end


  def insert_new_data(query_string, top_three_results, top_searched_result, most_reviewed, highest_rated)
    @data_fetch = DataFetch.new
    @data_fetch.date = Time.now.strftime("%d/%m/%Y %H:%M")
    @data_fetch.search_term = query_string
    @data_fetch.top_three_results = top_three_results.join(", ")
    @data_fetch.top_searched_result = top_searched_result
    @data_fetch.most_reviewed = most_reviewed
    @data_fetch.highest_rated = highest_rated
    @data_fetch.data = @brands
    @data_fetch.save
  end

  def create_new_product(name, model, brand)
    @product = Product.new
    @product.name = name
    @product.model = model
    @product.brand = Brand.find_by(name: brand)
    @product.save
  end

  def update_brand_info(name)
    @brand = Brand.find_by(name: name)
    @brand.result_count = @brands[name]["result_count"]
    @brand.result_percentage = @brands[name]["result_percentage"]
    @brand.top_three_percentage = @brands[name]["top_three_percentage"]
    @brand.top_three_count = @brands[name]["top_three"]["count"]
    @brand.top_three = @brands[name]["top_three"]
    @brand.save
  end

  def initialize_brand_data(name)
      @brand = Brand.new
      @brand.name = name
      @brand.result_count = 0
      @brand.result_percentage = "0%"
      @brand.top_three_percentage = "0%"
      @brand.top_three_count = 0
      @brand.top_three = {
          "count" => 0,
          "rank" => {
            "first" => {
              "count" => 0,
              "products" => {
                "total_review_count" => 0
              }
            },
            "second" => {
              "count" => 0,
              "products" => {
                "total_review_count" => 0
              }
            },
            "third" => {
              "count" => 0,
              "products" => {
                "total_review_count" => 0
              }
            }
          }
      }
      @brand.save
      save_to_brands(name)
  end

  def save_to_brands(name)
    @brands[name] = {
      "result_count" => 0,
      "result_percentage" => "0%",
      "top_three_percentage" => "0%",
      "top_three" => {
          "count" => 0,
          "rank" => {
            "first" => {
              "count" => 0,
              "products" => {
                "total_review_count" => 0
              }
            },
            "second" => {
              "count" => 0,
              "products" => {
                "total_review_count" => 0
              }
            },
            "third" => {
              "count" => 0,
              "products" => {
                "total_review_count" => 0
              }
            }
          }
      }
    }
  end


  def update_search_results(document)
    current_total_results = document.css("div.results-summary").text.split(" ")[7].to_i
    @brands["total_results"] += current_total_results
    document.css("li.facet-value").each do |el|
      if @brands[el.get_attribute('data-value')]
        @brands[el.get_attribute('data-value')]["result_count"] += el.get_attribute('data-count').to_i
        @brands[el.get_attribute('data-value')]["result_percentage"] = ((@brands[el.get_attribute('data-value')]["result_count"].to_f / @brands["total_results"]) * 100).round(2).to_s + "%"
      end
    end
  end

  def data_to_csv
    query_string = params[:query]

    if query_string == "brand"
      @item = Brand.all
    elsif query_string == "product"
      @item = Product.all
    elsif query_string == "data"
      @item = DataFetch.all
    end

    respond_to do |format|
      format.html
      format.csv { send_data @item.to_csv }
    end
  end

  def all_data_fetches
    @data = DataFetch.all

    render json: @data
  end

  def data_fetch
    today = params[:date].split("/").map {|x| x.to_i }
    @data = DataFetch.where(date: Date.new(*today))

    render json: @data
  end

  def all_brands
    @brands = Brand.all

    render json: @brands
  end

  def get_brand
    query_string = params[:brand].gsub("_", " ")
    @brand = Brand.where(name: query_string)

    render json: @brand
  end

  def all_products
    @products = Product.all

    render json: @products
  end

  def get_product
    query_string = params[:model]
    @product = Product.where(model: query_string)

    render json: @product
  end

  def data_for_dates
    date1 = params[:date1].split("/").map { |x| x.to_i }
    date2 = params[:date2].split("/").map { |x| x.to_i }
    @data = DataFetch.where(date: Date.new(*date1)..Date.new(*date2))

    render json: @data
  end



end
