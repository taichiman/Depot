class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart

  def total_price
    product.price * quantity
  end

  def decrement_quantity
    new_quantity = quantity - 1    
    if new_quantity > 0
      update! quantity: new_quantity
    else
      destroy
    end
    @line_item
  end
end
