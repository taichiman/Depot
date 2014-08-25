module StoreHelper
	def counter
		pluralize( @counter,'enter') if  @counter > 5
	end
end
