# This file contains all the record creation needed to seed the database with its default values.
# Your OAuth 2.0 Client Secret is: 15f0b6247e5c4f5a9f5fc80da5854a54 -do not remove (fatsecret key)
# (key: d1c88864830c4814a001a305f083b928)
Product.destroy_all
Supplier.destroy_all
Subcategory.destroy_all
Category.destroy_all
User.destroy_all
Address.destroy_all


#-------------------------------------- User creation---------------------------
#------------- Shopping preferences creation-------------
puts 'Creating Shoppping Preferences'
preferences = ["Ecological impact", "Nutritional Quality", "Price",]
preferences.each do |preference|
  pref = ShoppingPreference.new(
    name: preference
  )
  pref.save!
end
puts 'Creating User'
  #------------ Address creation----------------------
  puts 'Creating Address'
  addr = Address.new(
   street: "Place due Palud 2",
   zip: "1002",
   city: "Lausanne"
  )
addr.save!

user = User.new(
  firstname:"Emmanuel",
  lastname:"Ferreira",
  username:"emmanuelferreira",
  email:"emmanuel.ferreira@gmail.com",
  password: "123456",
  address_id: Address.find_by(street: "Place due Palud 2").id
)
user.save!
puts 'Done creating user'

puts 'Creating User Preferences'
ord = 0
3.times do
  ord += 1
  user_pref = UserPreference.new(
    user_id: User.first.id,
    order: ord,
    shopping_preference_id: ShoppingPreference.find_by(id: ord)
  )
  user_pref.save!
end


#-------------------------------- Category creation----------------------------------
puts 'Creating categories'
categories = %w(Drinks, Fruits, Vegetables, Bread & Baked Goods, Meat & Fish, Dairy Products & Eggs, Sweets, Snacks & Superfoods)
categories.each do |category|
  cat = Category.new(
    name: category
    )
  cat.save!
end
puts 'Done creating categories'

# -------------------------------Sub-Category creation-----------------------------------
puts 'Creating subcategories'
fruits = %w(Apples Pears Grapes Berries Bananas Kiwi Melons
            Pineapple Mangoes Citrus Exotic)
vegetables = %w(Potatoes Carrots Parsnips Celeriac Kohlrabi Beetroots Cabbage
                Broccoli Cauliflower Brussel Sprouts Cabbage Sauerkraut Red\ Cabbage
                Salad Vegetables Tomatoes Radishes Cucumbers Peppers Avocadoes Leaf Lettuce
                Courgettes Aubergine Sweetcorn Peas Bean Leek Fenne
                Mushroom Onions)
dairy = %w(Cheese Milk Creams Butter Margarine Yogurt Desserts Eggs )
meat = %w(Pork Beef Veal Lamb Chicken Seafood Fish Sausage Terrines Sausage Insects)
bakery = %w(Bread Tortillas Cookies Cakes Toast Pastry Tarts)
sweets =  %w(Crisps Popcorn Nuts Dried\ Fruit  Cereal\ Bars Chocolate Caramel & nougat)
drinks = %w(Mineral\ Water Sparkling\ Water Soft\ Drinks Fruit\ Juices Beer Cider Coffee Tea)
categories = [fruits, vegetables, dairy, meat, bakery, sweets, drinks]
categories.each do |category|
  category.each do |subcategory|
    subcat = Subcategory.new(
      name: subcategory,
      )
    subcat.save!
  end
end
puts 'Done creating subcategories'

# ----------------------------Supplier creation--------------------------------------
puts 'Creating suppliers'
suppliers = [["Coop", "Place de la Gare 9", "021 643 70 20"],
["Supermarché" "Avenue de Morges 60" "021 213 27 90"],
["ALDI" "Avenue du Chablais 3b" "021 626 12 57"],
["Migros" "Avenue de Sévelin 2" "058 573 74 30"],
["Top Marché" "Place Chauderon 32" "+41796441709"],
["Manor Food" "Avenue du Théâtre 4" "021 320 75 31"]]

suppliers.each do |supplier|
  Address.create(
    street: supplier[1],
    zip: "1004",
    city: "Lausanne"
    )

  supp = Supplier.new(
    name: supplier[0],
    address_id: Address.find_by(street: supplier[1]),
    phone: supplier[2]
    )
  supp.save!
end
puts 'Done creating suppliers'



 #------------------------ Creatin PRODUCTS------------------------------------------------

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

until num_queries == 5 do
  response = HTTParty.get(url, headers: headers)
  num_queries += 1
  raise unless response.code == 200 # HTTP OK
  json = JSON.parse(response.body)
  products += json['data']
  print "\rRetrieved products so far: #{products.length}..."
  url = json['links']['next']
  break if url.nil?



  puts 'Creating products in DB'
  products.each do |product|
    # barcode = product['barcode']
    # openfoodfacts_url = "https://world.openfoodfacts.org/api/v0/product/#{barcode}.json"
    prod = Product.new(
      barcode: product['barcode'],
      name: product['name_translations']["en"],
      # category_id: ,
      # subcategory_id: ,
      description: product["ingredients_translations"]["en"],
      origin: product["origin_translations"]["en"],
      expiration_date: Date.today() + rand(7..30),
      availability: "available",
      # price:,
      currency: "CHF",
      # nutri_score: ,
      # eco_score: ,
      # supplier_id:
    )
    unless product["images"][1].nil?
      prod.image = product["images"][1]["thumb"]
    end
    unless prod.barcode.blank? ||  prod.name.blank? || prod.image.blank?
      prod.save!
    end
  end
end

puts "\n#{products.length} products fetched from #{num_queries} queries."
puts "Time taken: #{(Time.now - START_TIME).round(1)} seconds"

# ----------------------Orders creation----------------------------------------




