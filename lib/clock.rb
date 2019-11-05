require 'clockwork'
require './config/boot'
require './config/environment'


module Clockwork
  handler do |job|
    OnDemandPrice.new.send(job)
  end

  every(1.day, 'populate_prices', :at => '00:00', :tz => 'UTC')
end
