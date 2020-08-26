# This file contains all the record creation needed to seed the database with its default values.
# Your OAuth 2.0 Client Secret is: 15f0b6247e5c4f5a9f5fc80da5854a54 -do not remove (fatsecret key)
# (key: d1c88864830c4814a001a305f083b928)
require 'openfoodfacts'
require 'httparty'
require 'json'
require 'faker'

Product.destroy_all
Supplier.destroy_all
Subcategory.destroy_all
Category.destroy_all
UserPreference.destroy_all
ShoppingPreference.destroy_all
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
while ord < 3 do
  user_pref = UserPreference.new(
    user_id: User.first.id,
    order: ord,
    shopping_preference_id: ShoppingPreference.find_by(name: preferences[ord - 1]).id
  )
  ord += 1
  user_pref.save!
end


#-------------------------------- Category creation----------------------------------
puts 'Creating categories'
categories = %w(Drinks Fruits Vegetables Bakery Meat\ &\ Fish Dairy Sweets Other\ Stuff)
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
other_stuff = %w(Miscellenneous)
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
suppliers = [["Coop", "Place de la Gare 9", "021 643 70 20"], ["Supermarché", "Avenue de Morges 60", "021 213 27 90"], ["ALDI", "Avenue du Chablais 3b", "021 626 12 57"],["Migros", "Avenue de Sévelin 2", "058 573 74 30"], ["Top Marché", "Place Chauderon 32", "+41796441709"], ["Manor Food", "Avenue du Théâtre 4", "021 320 75 31"]]

suppliers.each do |supplier|
  addr = Address.new(
    street: supplier[1],
    zip: "1004",
    city: "Lausanne"
    )
  addr.save!

  supp = Supplier.new(
    name: supplier[0],
    address_id: Address.find_by(street: "#{supplier[1]}").id,
    phone: supplier[2]
    )
  supp.save!
end
puts 'Done creating suppliers'


 #------------------------ Creatin PRODUCTS------------------------------------------------

# Sample Ruby code for multiple calls against the Food Repo API v3 products listing, with paging
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

until num_queries == 1 do
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
    # openfoodfacts_url = "https://world.openfoodfacts.org/api/v0/product/#{barcode}.json" in case wrapper does not work
    # open food data parsing
    barcode = product['barcode']
    prod = Openfoodfacts::Product.get(barcode, locale: 'world')

    next if product['name_translations']["en"].nil?
    next if product["origin_translations"]["en"].nil?
    next if prod.categories.nil?
    next if prod.nutriscore_grade.nil?


    prod_categories = prod.categories.split(",").map(&:strip)
    nutriscore = prod.nutriscore_grade

    # Get Subcategory id by comparing the subcategory array to a converted array (previously string) parsed with open foods api
    Subcategory.pluck(:name).each do |sub_category|
      if prod_categories.include?(sub_category)
        @subcat = Subcategory.find_by("name ILIKE ?", "%#{sub_category}%")
      end
    end
    @subcat = Subcategory.last if @subcat.nil?

    # Get category id based on subcategory
    if fruits.include?(@subcat.name)
      cat_id = Category.find_by(name: "Fruits").id
    elsif vegetables.include?(@subcat.name)
      cat_id = Category.find_by(name: "Vegetables").id
    elsif dairy.include?(@subcat.name)
      cat_id = Category.find_by(name: "Bakery").id
    elsif meat.include?(@subcat.name)
      cat_id = Category.find_by(name: "Meat & Fish").id
    elsif bakery.include?(@subcat.name)
      cat_id = Category.find_by(name: "Dairy").id
    elsif sweets.include?(@subcat.name)
      cat_id = Category.find_by(name: "Sweets").id
    elsif drinks.include?(@subcat.name)
      cat_id = Category.find_by(name: "Drinks").id
    else
      cat_id = Category.find_by(name: "Other Stuff").id
    end

    #ecoscore basic calculation
    ecoscore = "A" if product["origin_translations"]["en"].capitalize == "[\"Switzerland\"]" && nutriscore == "A"
    ecoscore = "B" if nutriscore == "B" || nutriscore == "A"
    ecoscore = "D" if nutriscore == "C"
    ecoscore = "E" if nutriscore == "D"
    ecoscore = "F" if nutriscore == "F" || nutriscore == "E"
    ecoscore = "C" if ecoscore.nil?

    # Supplier name random attribution
    supplier_name = []
    Supplier.all.each { |supplier| supplier_name << supplier.name}
    rand_name = supplier_name.sample

    prod = Product.new(
      barcode: product['barcode'],
      name: product['name_translations']["en"],
      category_id: cat_id,
      subcategory_id: @subcat.id,
      description: product["ingredients_translations"]["en"],
      origin: product["origin_translations"]["en"],
      expiration_date: Date.today() + rand(7..30),
      availability: "available",
      price: Faker::Commerce.price(range: 0..10.0),
      currency: "CHF",
      nutri_score: nutriscore.capitalize,
      eco_score: ecoscore,
      supplier_id: Supplier.find_by(name: rand_name).id
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




