require 'openfoodfacts'


barcode = '737628064502'
# openfoodfacts_url = "https://world.openfoodfacts.org/api/v0/product/#{barcode}.json"
product = Openfoodfacts::Product.get(barcode, locale: 'world')

puts product.categories.class
puts product.nutriscore_grade.class

