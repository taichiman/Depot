require 'test_helper'

class CartsControllerTest < ActionController::TestCase
  setup do
    @cart = carts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:carts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cart" do
    assert_difference('Cart.count') do
      post :create, cart: {  }
    end

    assert_redirected_to cart_path(assigns(:cart))
  end

  test "should show cart" do
    @cart.add_product products(:one)
    @cart.save

    session[:cart_id] = @cart.id
    get :show, id: @cart
    assert_response :success
    
    assert_select '#del-button'
  end

  test "should get edit" do
    get :edit, id: @cart
    assert_response :success
  end

  test "should update cart" do
    patch :update, id: @cart, cart: {  }
    assert_redirected_to cart_path(assigns(:cart))
  end

  test "should destroy cart" do
    assert_difference('Cart.count', -1) do
      session[:cart_id] = @cart.id
      delete :destroy, id: @cart
    end

    assert_redirected_to store_url
  end

  # === my tests 
  
  test "should hide cart if there are no products in the cart" do
    @cart.line_items.delete_all
    assert_equal @cart.line_items.count, 0
    
    get :index, {}, cart_id: @cart.id

    assert_response :success
    assert_select '#cart[style*=none]'
  end

  test "should show cart if there are products in the cart" do
    assert_equal 1, @cart.line_items.count
    get :index, {}, cart_id: @cart.id

    assert_response :success
    assert_select '#cart'
    assert_select '#cart[style=display:none;]', 0
  end
end
