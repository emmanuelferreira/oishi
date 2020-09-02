# This file contains all the record creation needed to seed the database with its default values.
# Your OAuth 2.0 Client Secret is: 15f0b6247e5c4f5a9f5fc80da5854a54 -do not remove (fatsecret key)
# (key: d1c88864830c4814a001a305f083b928)
require 'openfoodfacts'
require 'httparty'
require 'json'
require 'faker'

OrderProduct.destroy_all
Product.destroy_all
Order.destroy_all
Supplier.destroy_all
Subcategory.destroy_all
Category.destroy_all
UserPreference.destroy_all
ShoppingPreference.destroy_all
User.destroy_all
Address.destroy_all
# PlaylistProduct.destroy_all
# Playlist.destroy_all

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

until num_queries == 2 do
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
    next if Product.exists?(barcode: product['barcode'])
    next if product['name_translations']["en"].nil?
    next if product["origin_translations"]["en"].nil?
    next if prod.nutriscore_grade.nil?
    next if prod.image_url.nil?
    next if prod.categories_tags.nil?
    next if prod.origins.nil?
    next if prod.image_nutrition_small_url.nil?
    next if prod.quantity.nil?
    next if prod.nutriments.nil?


    prod_category = prod.categories_tags.map{|element| element.sub('en:','')}.first.capitalize #or .pnns_groups_2_tags.first   .pnns_groups_1 without any mehtod after
    nutriscore = prod.nutriscore_grade

    #-------------------------------- Category creation----------------------------------
    
    puts 'Creating categories'
    if Category.find_by(name: prod_category).nil?
      cat = Category.new(
        name: prod_category
      )
      cat.save!
    else
      cat = Category.find_by(name: prod_category)
    end
    puts 'Done creating categories'


    #ecoscore basic calculation
    ecoscore = "A" if prod.origins.capitalize == "Switzerland"
    ecoscore = "B" if nutriscore.capitalize == "A" && prod.origins.capitalize != "Switzerland"
    ecoscore = "C" if nutriscore.capitalize == "B" && prod.origins.capitalize != "Switzerland"
    ecoscore = "D" if nutriscore.capitalize == "C" && prod.origins.capitalize != "Switzerland"
    ecoscore = "E" if nutriscore.capitalize == "D" && prod.origins.capitalize != "Switzerland"
    ecoscore = "F" if nutriscore.capitalize == "F" || nutriscore == "E" && prod.origins.capitalize != "Switzerland"
    ecoscore = "C" if ecoscore.nil?


    # Supplier name random attribution
    supplier_name = []
    Supplier.all.each { |supplier| supplier_name << supplier.name}
    rand_name = supplier_name.sample

    produit = Product.new(
      barcode: product['barcode'],
      name: product['name_translations']["en"],
      category_id: cat.id,
      description: product["ingredients_translations"]["en"],
      origin: prod.origins,
      expiration_date: Date.today() + rand(7..30),
      availability: "available",
      price: Faker::Commerce.price(range: 1..5.0).round(2),
      currency: "CHF",
      nutri_score: nutriscore.capitalize,
      eco_score: ecoscore,
      supplier_id: Supplier.find_by(name: rand_name).id,
      nutriments: prod.nutriments,
      quantity_product: prod.quantity,
      image_nutrition: prod.image_nutrition_small_url
    )

    produit.image = prod.image_url

    unless produit.barcode.blank? ||  produit.name.blank? || produit.image.blank?
      produit.save!
    end
  end
end

puts "\n#{products.length} products fetched from #{num_queries} queries."
puts "Time taken: #{(Time.now - START_TIME).round(1)} seconds"

# ----------------------Orders creation this month----------------------------------------#
3.times do
  status = ["pending","delivered"].sample
  d = Date.today
  ord = Order.new(
    status: status,
    user_id: User.first.id,
    deliver_date: status == "delivered" ? d - rand(1..10) : d + 1,
    address_id: User.first.address.id,
  )
  ord.save!
  rand(3..10).times do
    n = 0
    products = Product.all.shuffle.each{|x|}
    product = products[n]
    quantity = rand(1..3)
    ord_prod = OrderProduct.new(
      order_id: ord.id,
      product_id: product.id,
      quantity: quantity,
      unit_price: product.price,
      total_price: quantity * product.price
    )
    ord_prod.save!
  end
  ord.total = OrderProduct.where(order_id: ord.id).map(&:total_price).inject(0, &:+)
  ord.payment_amount = ord.total

  puts "Order Poduct create"
  ord.save!
  puts "Order created"
end


# ----------------------Orders creation last month----------------------------------------#
7.times do
  status = ["delivered"].sample
  d = Date.today
  ord = Order.new(
    status: status,
    user_id: User.first.id,
    deliver_date: status == "delivered" ? d - rand(31..50) : d + 1,
    address_id: User.first.address.id,
  )
  ord.save!
  rand(3..10).times do
    n = 0
    products = Product.all.shuffle.each{|x|}
    product = products[n]
    quantity = rand(1..3)
    ord_prod = OrderProduct.new(
      order_id: ord.id,
      product_id: product.id,
      quantity: quantity,
      unit_price: product.price,
      total_price: quantity * product.price
    )
    ord_prod.save!
  end
  ord.total = OrderProduct.where(order_id: ord.id).map(&:total_price).inject(0, &:+)
  ord.payment_amount = ord.total

  puts "Order Poduct create"
  ord.save!
  puts "Order created"
end
# # ----------------------playlist-------------------------------------------------#
# # -------------------------eco----------------------------------------------#
  
#   eco = Playlist.new(
#     name: "eco_score"  
#   )
#   eco.save!
#   categories =Category.all
#   categories.each  do |category|
#     2.times do
#       n = 0
#       quantity = rand(1..3)
#       products = Product.where(category_id:category.id).where(eco_score:"A").shuffle.each{|x|}
#       if !products.empty?
#       product = products[n]
#       playlist_product = PlaylistProduct.new(
#         playlist_id: eco.id,
#         product_id: product.id,
#         quantity: quantity,
#       )
#       playlist_product.save!
#       n=n+1
#       end
#     end
#   end

# # -------------------------nutri----------------------------------------------#
  
# nutri = Playlist.new(
#   name: "nutri_score"  
# )
# nutri.save!
# categories =Category.all
# categories.each  do |category|
#   2.times do
#     n = 0
#     quantity = rand(1..3)
#     products = Product.where(category_id:category.id).where(nutri_score:"A").shuffle.each{|x|}
#     if !products.empty?
#     product = products[n]
#     playlist_product = PlaylistProduct.new(
#       playlist_id: nutri.id,
#       product_id: product.id,
#       quantity: quantity,
#     )
#     playlist_product.save!
#     n=n+1
#     end
#   end
# end

# # -------------------------price----------------------------------------------#
  
# price = Playlist.new(
#   name: "price_score"  
# )
# price.save!
# categories =Category.all
# categories.each  do |category|
#   2.times do
#     n = 0
#     quantity = rand(1..3)
#     products = Product.where(category_id:category.id).order('price ASC')
#     if !products.empty?
#       product = products[n]
#       playlist_product = PlaylistProduct.new(
#         playlist_id: price.id,
#         product_id: product.id,
#         quantity: quantity,
#       )
      
#     playlist_product.save!
#     n=n+1
#     end
#   end
# end

  