require 'rubygems'
require 'bundler'

Bundler.require
$: << File.expand_path('../', __FILE__)
Dir[__dir__ + "/lib/*.rb"].each { |file| require file }

require 'dotenv'
require 'sinatra/base'

Dotenv.load

$redis = Redis.new

module ApartmentBuzzer
  class App < Sinatra::Application
    # Twilio incoming call webhook.
    get "/buzzer" do
      content_type "text/xml"

      buzzer_response.generate
    end

    # Incoming SMS messages.
    post "/message" do
      # Twilio SMS POST attributes: https://www.twilio.com/docs/api/twiml/sms/twilio_request#synchronous.
      if params[:Body].match(/^.*(landlord|toggle|🎚|switch|yes|no).*$/i)
        buzzer_response.toggle_landlord
      else
        Twilio::TwiML::MessagingResponse.new.message(body: "Wut 🤔").to_s
      end
    end

    private

    def buzzer_response
      @buzzer_response ||= BuzzerResponse.new(params[:phone_number])
    end
  end
end
