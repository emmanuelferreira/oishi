# This file contains all the record creation needed to seed the database with its default values.
# Your OAuth 2.0 Client Secret is: 15f0b6247e5c4f5a9f5fc80da5854a54 -do not remove (fatsecret key)
# (key: d1c88864830c4814a001a305f083b928)
Product.destroy_all
Supplier.destroy_all
Subcategory.destroy_all
Category.destroy_all
User.destroy_all
Address.destroy_all
# User creation
puts 'Creating Address'
addr = Address.new(
 street: "Place due Palud 2",
 zip: "1002",
 city: "Lausanne"
)
addr.save!

# User creation
puts 'Creating User'
user = User.new(
  firstname:"Emmanuel",
  lastname:"Ferreira",
  username:"emmanuelferreira",
  email:"emmanuel.ferreira@gmail.com",
  password: "123456",
  address_id: Address.first.id
)
user.save!
puts 'Done creating user'


# Category creation
puts 'Creating categories'
categories = %w(Drinks, Fruits, Vegetables, Bread & Baked Goods, Meat & Fish, Dairy Products & Eggs, Sweets, Snacks & Superfoods)
categories.each do |category|
  cat = Category.new(
    name: category
    )
  cat.save!
end
puts 'Done creating categories'

# Sub-Category creation
puts 'Creating subcategories'
fruits = %w(Apples & Pears, Grapes & Berries, More Garden Fruit,Bananas, Kiwi & Melons,
            Pineapple & Mangoes, Citrus Fruit, More Exotic Fruit)
vegetables = %w(Potatoes,Carrots & Parsnips,Celeriac & Kohlrabi,Beetroots,Cabbage,
                Broccoli & Cauliflower,Brussel Sprouts & Cabbage,Sauerkraut & Red Cabbage,
                Salad Vegetables,Tomatoes,Radishes,Cucumbers,Peppers,Avocadoes,Salads,Leaf Lettuce,
                Pre-Packaged Fresh Salads,More Vegetables,Courgettes & Aubergine,Sweetcorn, Peas & Bean,Leek & Fenne,
                Leaf Vegetable,Mushroom,Seasonal Vegetable,Prepared Vegetable,Herbs & Spice
                ,Onions & Garli,Fresh Herb,Sprouts & Watercres,Chilli, Lemongrass & Ginger)
dairy = %w(Semi-hard Cheese,Raclette & Fondue,Hard Cheese,Soft Cheese,Fresh Cheese & Mozzarella,
          Soft Cheese,Hard & Semi-Hard Cheese,Sheep, Goat & Feta Cheese,Raclette & Fondue,Grated Cheese,
          Processed & Grilled Cheese,Cheese Snacks & Appetizers,Milk,Fresh Milk,UHT Milk,Milk Specialities,
          Boissons lactées froides,Cream,Full-Fat Cream & Half-Fat Cream,Coffee Cream,Whipped Cream,
          Cream Specialities,Butter & Margarine,Unsalted Butter,Margarine,Seasoned Butter,Cooking Butter & Cooking Fat,
          Yogurt,Natural Yogurt,Flavoured Yogurt,Special Yogurt & Muesli,Quark,Flavoured Quark,
          Natural Quark,Desserts & Cream,Cream & Mousse,Pudding & Flan,Rice Pudding & Semolina,
          Milk Snacks,Special Desserts,Eggs,Raw Eggs,Hard-Boiled Eggs)
meat = %w(Pork,Beef,Veal,Lamb,Chicken,Dry-aged Beef,Marinades,Seafood Market,Fresh Fish,
          Seafood,Packaged Fresh Meat,Poultry,Pork,Veal,Beef,Lamb,Ground Meat,
          Pork Products & Offal,Demeter organic Meat Packets,Cold Cuts & Sausage Products,
          Sausages,Bacon & Diced Ham,Ham & Cold Cuts,Dried Meat & Salami,Patés,
          Terrines & Sausage Spread,Snacks & Appetizers,Breaded & Ready-to-Cook,Insects,
          Packaged Fish,Packaged Fresh Fish,Smoked Fish,Shellfish & Seafood,Fish Specialities & Roe)
bakery = %w(Bread, Small Rolls, Tresse, Durable Breads, Ready-to-Bake Breads, Toasting Bread & Buns,
            Durable Breads, Flatbread & Tortillas, Cookies & Cakes, Cookies with Chocolate,
            Cookies without Chocolate, Cookie Assortments, Hüppen, Wafers & Läckerli,
            Cakes & Tarts, Meringues, Sweet Bread Rolls & Panettone, Crackers & Crispbreads,
            Crackers, Melba Toast, Rice Cakes, Crispbreads & Crisprolls, Pastry Dough & Cake Bases,
            Puff Pastry, Pie Dough, Pizza & Pasta Dough, Cake Bases & Tarts)
sweets =  %w(risps & Snacks, Crisps & Popcorn, Savoury Snacks & Breadsticks, Salted Nuts,
            Dried Fruit & Nuts, Cereal Bars, Chocolate & Confectionery, Chocolate Bars, Chocolate Sticks & Snacks,
            Chocolate Pralines, Caramel & nougat, Sweets, Chewing Gum,
            Health and Sports, Superfood, Proteins, Energy, Figure)
drinks = %w(Mineral Water, Sparkling, Still, Flavoured, Multipacks more than 1 Liter,
            Multipacks under 1 Liter, Soft Drinks, Cola & Limonades, Ice Tea, Sport & Energy Drinks,
            Bitter & Tonic Water, Syrup, Multipacks more than 1 Liter, Multipacks under 1 Liter,
            Fruit & Vegetable Juices, Fresh Juices & Smoothies, Hot Drinks, Tea,
            Ovomaltine & Malt Drinks, Chocolate, Beer, Blonde & Lager, Dark Beer,
            Ale & Amber, Wheat, Alcohol-Free Beer, Blended Beer & Cider, Beer Multipacks,
            Multipacks more than 12x50cl, Coffee, Coffee Beans, Ground Coffee,
            Coffee Capsules, Instant Coffee)
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



# Supplier creation // to rewooooooooork
puts 'Creating suppliers'
supplier_names = ["Coop", "Migros", "Lidl"]
supplier_names.each do |supplier|
  supp = Supplier.new(
    name: supplier,
    address_id: Address.first.id
    )
  supp.save!
end
puts 'Done creating suppliers'




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


  # Creatin PRODUCTS in Database base on above JSON input
  puts 'Creating products in DB'
  products.each do |product|
    # barcode = product['barcode']
    # openfoodfacts_url = "https://world.openfoodfacts.org/api/v0/product/#{barcode}.json"

    prod = Product.new(
      barcode: product['barcode'],
      name: product['name_translations']["en"],
      category_id: Category.first.id,
      subcategory_id: Subcategory.first.id,
      description: product["ingredients_translations"]["en"],
      origin: product["origin_translations"]["en"],
      expiration_date: Date.today() + rand(7..30),
      availability: "available",
      price: rand(2..10),
      currency: "CHF",
      nutri_score: ('A'..'F').to_a.sample,
      eco_score: ('A'..'F').to_a.sample,
      supplier_id: Supplier.first.id
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




