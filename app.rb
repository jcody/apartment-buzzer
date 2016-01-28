require 'rubygems'
require 'bundler'

# Setup load paths
Bundler.require
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'dotenv'
Dotenv.load

require 'sinatra/base'
Dir['lib/**/*.rb'].sort.each { |file| require file }

# require 'app/extensions'
# require 'app/models'
# require 'app/helpers'
# require 'app/routes'

module ApartmentBuzzer
  class App < Sinatra::Application
    # configure do
    #   Twilio.configure do |config|
    #     config.account_sid = ENV['TWILIO_ACCOUNT_SID']
    #     config.auth_token = ENV['TWILIO_AUTH_TOKEN']
    #   end
    # end

    get "/buzzer" do
      @phone_number = params[:phone_number]

      content_type 'text/xml'
      "<?xml version='1.0' encoding='UTF-8'?>
      <Response>
        <Say voice='woman'>Forwarding your call to Joey's cell phone.</Say>
        <Dial>#{@phone_number}</Dial>
      </Response>"

    end
  end
end
