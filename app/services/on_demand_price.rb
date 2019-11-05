require 'net/http'

class OnDemandPrice
	PRICE_URI = 'https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonCloudFront/current/index.json'

	def populate_prices
		begin
			on_demand_prices = JSON.parse(Net::HTTP.get(URI.parse(PRICE_URI)))
			price_dimensions = ihash(on_demand_prices.dig('terms', 'OnDemand'))

			price_dimensions.each_with_index do |price_dimension, i|
				if price_dimension.keys.include?(:sku)
					price = Price.find_or_create_by(sku: price_dimension[:sku], effective_date: price_dimensions[i+1][:effectiveDate])
					price.update_attribute(:region, 'us-east-1')
					price.price_dimensions.create!(description: price_dimensions[i+2][:description], begin_range: price_dimensions[i+3][:beginRange], end_range: price_dimensions[i+4][:endRange], unit: price_dimensions[i+5][:unit], price_per_unit: price_dimensions[i+6][:USD])		
				end
			end			
		rescue Exception => e
			logger.warn "Unable to populate prices for #{self.class.name}: #{e}"
		end
	end

	def ihash(h)
		price_dimensions = []
		h.each_pair do |k, v|
	    if v.is_a?(Hash)
	      puts "key: #{k} recursing..."
	      price_dimensions << ihash(v)
	    else
	      puts "key: #{k} value: #{v}"
	      price_dimensions << {"#{k}": v} if ['sku', 'effectiveDate', 'description', 'beginRange', 'endRange', 'unit', 'USD'].include?(k)
	    end
	  end
	  price_dimensions.flatten
	end
end