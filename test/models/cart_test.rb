require 'test_helper'

class CartTest < ActiveSupport::TestCase
  test "add a product two times" do
    assert_difference( 'LineItem.count' ) do
      carts(:one).add_product products(:unique)
      carts(:one).save
    end

    assert_no_difference "LineItem.count", "Doubled product line should't be added" do
      carts(:one).add_product products(:unique)
      carts(:one).save
    end
  end
end
