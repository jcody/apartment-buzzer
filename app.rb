require 'rubygems'
require 'bundler'

Bundler.require
$: << File.expand_path('../', __FILE__)
Dir[__dir__ + "/lib/*.rb"].each { |file| require file }

require 'dotenv'
Dotenv.load

require 'sinatra/base'

module ApartmentBuzzer
  class App < Sinatra::Application
    get "/buzzer" do
      content_type "text/xml"
      BuzzerResponse.new.generate
    end

    # When you want to toggle automagic buzzing/forward calls to your phone.
    post "/message" do
      # Twilio SMS POST attributes: https://www.twilio.com/docs/api/twiml/sms/twilio_request#synchronous.
      if params[:Body].match(/^.*(landlord|fuck|💩|😱).*$/)
        BuzzerResponse.new.toggle_landlord
      else
        # If message isn't holy-shit-landlord-is-there-right-now,
        # respond with the lulz ¯\_(ツ)_/¯.
        BuzzerResponse.new.lol_response
      end
    end
  end
end
