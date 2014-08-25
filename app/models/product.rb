class Product < ActiveRecord::Base
	validates :title, :image_url, :price, presence: true
	validates :description, presence: { message: 'Please, fill the field' }

	validates :price, numericality: {greater_than_or_equal_to: 0.01}
	validates :title, uniqueness: true, length: { minimum: 10}
	validates :image_url, allow_blank: true, format: {
		with: %r{\.(gif|jpg|png)\Z}i,
		message: 'must be a URL for GIF, JPG or PNG image'
	}

	has_many :line_items

	before_destroy :ensure_not_referenced_by_any_line_item

	def self.latest
		Product.order(:updated_at).last
	end

	private

		#ensure that there  are no line items referenced this product
		def ensure_not_referenced_by_any_line_item
			if line_items.empty?
				true
			else
				errors.add :base, 'Line Items present'
				return false
			end
		end
end
