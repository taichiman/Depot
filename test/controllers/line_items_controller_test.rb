require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  setup do
    @line_item = line_items(:one)
    @cart = carts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:line_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post :create, product_id: products(:ruby).id
    end

    assert_redirected_to store_path
  end

  test "shoul create line_item via ajax" do
    assert_difference "LineItem.count" do
      xhr :post, :create, product_id: products(:ruby).id 
    end

    assert_response :success
    assert_select_jquery :html, '#cart' do
      assert_select 'tr#current_item td', /Programming Ruby 1.9/
    end
  end

  test "should show line_item" do
    get :show, id: @line_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @line_item
    assert_response :success
  end

  test "should update line_item" do
    patch :update, id: @line_item, line_item: { product_id: @line_item.product_id }
    assert_redirected_to line_item_path(assigns(:line_item))
  end

  test "should destroy line_item" do
    assert_difference('LineItem.count', -1) do
      delete :destroy, id: @line_item
    end

    assert_redirected_to store_path
  end

  # === my tests

  test "should add product to cart when cart is showing" do
    @cart.line_items.delete_all
    session[:cart_id] = @cart.id

    assert_difference( '@cart.line_items.count', 2 ) do
      xhr :post, :create, { product_id: products(:one).id }
      xhr :post, :create, { product_id: products(:ruby).id }
    end

    assert_response :success
    assert_select_jquery :html, '#cart' do
      assert_select 'tr', 3
    end
  end

  test "should decrement quantity of product" do
    @cart.line_items.first.increment! :quantity
    session[:cart_id] = @cart.id

    assert_difference('@cart.line_items.first.quantity', -1) do
      xhr :post, :decrement, { id: @cart.line_items.first.id }
    end

    assert_match /1 &times;/, response.body
  end

  test "should destroy a line item if quantity eq 0" do
    session[:cart_id] = @cart.id

    assert_difference('@cart.line_items.count', -1) do
      xhr :post, :decrement, { id: @cart.line_items.first.id }
    end

    assert_no_match /1 &times;/, response.body
  end
end
