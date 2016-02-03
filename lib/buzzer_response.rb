class BuzzerResponse
  attr_accessor :phone_number

  def initialize(phone_number)
    @phone_number = phone_number
  end

  def generate
    return landlord_home_response if landlord_home?

    default_response
  end

  def landlord_home?
    ENV["LANDLORD_HOME"] == "true"
  end

  def caller_id_number
    ENV["TWILIO_PHONE_NUMBER"]
  end

  private

  def default_response
    <<-EOS
    <Response>
      <Say voice='man' language='en-gb'>Welcome home old chap!</Say>
      <Play digits='9'></Play>
    </Response>
    EOS
  end

  def landlord_home_response
    <<-EOS
    <Response>
      <Dial callerId='#{caller_id_number}'>#{phone_number}</Dial>
    </Response>
    EOS
  end
end
