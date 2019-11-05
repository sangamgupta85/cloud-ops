class Price < ApplicationRecord
	has_many :price_dimensions, dependent: :destroy

	validates_uniqueness_of :sku, scope: [:effective_date, :region]

	class << self
		def price_attributes
			joins(:price_dimensions).select('prices.effective_date, price_dimensions.description, price_dimensions.begin_range, price_dimensions.end_range, price_dimensions.unit, price_dimensions.price_per_unit')
		end
	end
end
