# Best Buy Data Collection

This application is an API designed to be a tool for collecting search results data from bestbuy.com. Currently, it provides data for the following brands based on search term: **Samsung, LG, Toshiba, and Sony**.


## Installation
Running the application locally:
  - Clone the repository
  - Ensure you have [postgresql](https://www.postgresql.org/download/), [ruby](https://www.ruby-lang.org/en/documentation/installation/), and [rails](http://installrails.com/) installed on your machine
  - cd into the project folder
  - run "bundle install" in your command line
  - run "rails s" to start the server
  - visit localhost:3000

Alternatively, you can use the [live application](https://best-buy-data-collection.herokuapp.com/).

## API ENDPOINTS

| Endpoint | Example | Description |
| --- | --- | --- |
| `/collections` | api/collections?query=smart+tv | Will perform data collection from bestbuy.com with search term "smart tv" and output collected data in JSON format |
| `/collections/data.csv` | api/collections/data.csv?query=brand | Will output Brand table from database into csv format |
| `/collections/data_fetches` | api/collections/data_fetches | Will output all collected data from DataFetch table in JSON format |
| `/collections/data_fetch` | api/collections/data_fetch?date=2017/9/4 | Will output all collected data from DataFetch table matching the date provided in the query string in JSON format |
| `/collections/brands` | api/collections/brands | Will output Brand table in JSON format |
| `/collections/brand` | api/collections/brand?brand=Samsung | Will output data from Brand table matching name with the provided query string in JSON format |
| `/collections/products` | api/collections/products | Will output Product table in JSON format |
| `/collections/product` | api/collections/product?model=UN65MU8500FXZA | Will output data from Product table matching model with provided query string in JSON format |
| `/collections/data_fetch/dates` | api/collections/data_fetch/dates?date1=2017/9/4&date2=2017/9/5 | Will output all collected data from DataFetch table between the dates provided in the query string in JSON format |

## Technologies and Libraries

- Ruby on Rails
- PostgreSQL
- Nokogiri
- CSV

Example CSV data

- [Data](https://github.com/jestir1234/best-buy-data/blob/master/data.csv)

- [Brand](https://github.com/jestir1234/best-buy-data/blob/master/brands.csv)
