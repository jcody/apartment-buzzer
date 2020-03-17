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
    # Twilio incoming call webhook.
    get "/buzzer" do
      content_type "text/xml"

      BuzzerResponse.new(params[:phone_number]).generate
    end
  end
end
