class StoreController < ApplicationController
  def index
  	@counter  = counter
  	@products = Product.order :title
  end

  def counter
		if session[:count_entrance].nil?
  		session[:count_entrance] = 1
  	else 
  		session[:count_entrance]+= 1
  	end
  end
end
