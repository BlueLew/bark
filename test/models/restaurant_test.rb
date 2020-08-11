require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase

	def setup
		@restaurant = Restaurant.new(name: "Lew's Cafe")
	end
	
	test "name should be present" do
		@restaurant.name =  " "
		assert_not @restaurant.valid?
	end

	test "name should be unique" do
		@restaurant.save
		@restaurant2 = Restaurant.new(name: "Lew's Cafe")
		assert_not @restaurant2.valid?
	end

	test "name should not be too long" do
		@restaurant.name = "a" * 26
		assert_not @restaurant.valid?
	end

	test "name should not be too short" do
		@restaurant.name = "a"
		assert_not @restaurant.valid?
	end
end
