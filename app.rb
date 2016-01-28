require 'rubygems'
require 'bundler'

Bundler.require
$: << File.expand_path('../', __FILE__)

require 'dotenv'
Dotenv.load

require 'sinatra/base'

module ApartmentBuzzer
  class App < Sinatra::Application

    get "/buzzer" do
      @phone_number = params[:phone_number]

      content_type 'text/xml'
      "<?xml version='1.0' encoding='UTF-8'?>
      <Response>
        <Dial callerId='14157499353'>#{@phone_number}</Dial>
      </Response>"

    end
  end
end
