class BuzzerResponse
  attr_accessor :phone_number

  def initialize(phone_number)
    @phone_number = phone_number
  end

  def generate
    puts "Landlord home/should dial user: #{landlord_home?}"
    return landlord_home_response if landlord_home?

    default_response
  end

  def landlord_home?
    ENV["LANDLORD_HOME"] == "true"
  end

  def caller_id_number
    ENV["TWILIO_PHONE_NUMBER"]
  end

  def resident_number
    ENV["RESIDENT_PHONE_NUMBER"]
  end

  private

  def default_response
    <<-EOS
    <Response>
      <Say voice='man' language='en'></Say>
      <Sms from='#{caller_id_number}' to='#{resident_number}'>Guest arrived @ 1761 Vallejo St.</Sms>
      <Play digits='9'></Play>
      <Hangup/>
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
