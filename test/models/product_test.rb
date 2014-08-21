require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	fixtures :products

	test "product attributes must not be empty" do
		product = Product.new
		assert product.invalid?
		assert product.errors[:title].any?
		assert product.errors[:description].any?
		assert product.errors[:image_url].any?
		assert product.errors[:price].any?
	end

	test "product price must be positive" do
		product = Product.new title: 			 "My Book Title",
													description: "yyy",
													image_url: 	 "zzz.jpg"
		product.price = -1
		assert product.invalid?
		assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

		product.price = 0
		assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
		
		product.price = 1
		assert product.valid?
	end

	def new_product_with_image image_url
		Product.new title: 			 "My Book Title",
								description: "yyy",
								image_url: 	 image_url,
								price: 			 1
	end

	test "image_url" do
		ok  = %w( fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif)
		bad = %w( fred.doc fred.gif/more fred.gif/more )

		ok.each  { |name| assert new_product_with_image(name).valid?, "#{name} should be valid" }
		bad.each { |name| assert new_product_with_image(name).invalid?, "#{name} should be invalid" }
	end

	test "product is not valid without unique title" do
		product = Product.new title: products(:ruby).title,
													description: "yyy",
													image_url: "fred.gif",
													price: 1
		assert product.invalid?
		assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
	end

	def new_product_with_tile_length title
		Product.new title: 			 title,
								description: "yyy",
								image_url: 	 'image.jpg',
								price: 			 1
	end

	test "title length must be greater than 10 characters" do
		ok  = %w( 1234567890 Michael\ Jackson)
		bad = %w( '' foo )

		bad.each do |title|
			product = new_product_with_tile_length title
			assert product.invalid?
			assert_equal ['is too short (minimum is 10 characters)'], product.errors[:title]
		end

		ok.each do |title|
			product = new_product_with_tile_length title
			assert product.valid?
		end
	end
end
