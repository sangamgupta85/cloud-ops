class PricesController < ApplicationController
	def price_dimension
		if params[:region]
			prices = Price.price_attributes.where(region: params[:region])
		elsif params[:date]
			prices = Price.price_attributes.where(effective_date: params[:date])
		else
			prices = Price.price_attributes
		end
		render json: prices, status: :ok
	end

end
