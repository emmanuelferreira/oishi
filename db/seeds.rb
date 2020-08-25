# This file contains all the record creation needed to seed the database with its default values.


# Sample Ruby code for multiple calls against the Food Repo API v3 products listing, with paging
require 'httparty'
require 'json'





BASE_URL = 'https://www.foodrepo.org/api/v3'
KEY = '9ea7424b86b666b97c53a8ed2dadb21b'
ENDPOINT = '/products'
DESTINATION = 'foodrepo_products_snapshot.json'
START_TIME = Time.now

url = BASE_URL + ENDPOINT + '?page%5Bsize%5D=200'
headers = {
  'Authorization' => "Token token=#{KEY}",
  'Accept' => 'application/json',
  'Content-Type' => 'application/vnd.api+json'
}
products = []
num_queries = 0
puts 'Fetching products from FoodRepo API...'

loop do
  response = HTTParty.get(url, headers: headers)
  num_queries += 1
  raise unless response.code == 200 # HTTP OK
  json = JSON.parse(response.body)
  products += json['data']
  print "\rRetrieved products so far: #{products.length}..."
  url = json['links']['next']
  break if url.nil?


  # Creatin PRODUCTS in Database base on above JSON input
   puts 'Creating products in DB'
  products.each do |product|
    barcode = product['barcode']
    openfoodfacts_url = "https://world.openfoodfacts.org/api/v0/product/#{barcode}.json"


  # product = Product.new(
  #   barcode: product['barcode'],
  #   name: product['name_translations']["en"],
  #   category_id:,
  #   sub
  #   description: product["ingredients_translations"]["en"],
  #   origin: product["origin_translations"]["en"],
  #   expiration_date:,
  #   availability:,
  #   price:,
  #   currency: "CHF",
  #   nutri_score:,
  #   eco_score:,
  #   supplier_id:,
  #   image: product["images"][1]["thumb"]
  # )
  # product.save!
  end
end


puts "\n#{products.length} products fetched from #{num_queries} queries."
puts "Time taken: #{(Time.now - START_TIME).round(1)} seconds"



