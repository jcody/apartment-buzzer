class TwilioAPI
  def self.toggle_landlord_home!
    if ENV["LANDLORD_HOME"] == "true"
      patch({ "LANDLORD_HOME" => false })
    else
      patch({ "LANDLORD_HOME" => true })
    end
  end

  def self.connection
    @connection ||= Faraday.new(url: config_vars_endpoint) do |c|
      c.adapter Faraday.default_adapter
    end
  end

  def self.patch(data)
    # Below 'Accept' header value comes from documentation example. No idea if/why it's needed.
    # https://devcenter.heroku.com/articles/platform-api-reference#config-vars-update-curl-example
    connection.patch do |r|
      r.body = data.to_json
      r.headers["Accept"] = "application/vnd.heroku+json; version=3"
      r.headers["Content-Type"] = "application/json"
    end
  end

  # Twilio API url with application name allows for RESTful config variable management.
  #
  # See: https://devcenter.heroku.com/articles/platform-api-reference#config-vars-info-for-app
  def self.config_vars_endpoint
    "https://api.heroku.com/apps/#{ENV['TWILIO_APP_NAME']}/config-vars"
  end
end
