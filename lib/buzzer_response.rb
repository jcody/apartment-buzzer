class BuzzerResponse
  def initialize
    # Used to be a nice voice data object, now everything is crammed into this lib class.
  end

  def generate
    return landlord_home_response if landlord_home?

    default_response
  end

  def toggle_landlord
    TwilioAPI.toggle_landlord_home!

    toggle_landlord_response
  end

  def lol_response
    <<-EOS
    <Response>
      <Sms from='#{twilio_virtual_number}' to='#{resident_number}'>
        Suhhh dude 🤙?!
      </Sms>
    </Response>
    EOS
  end

  private

  def landlord_home?
    ENV["LANDLORD_HOME"] == "true"
  end

  def twilio_virtual_number
    ENV["TWILIO_PHONE_NUMBER"]
  end

  def resident_number
    ENV["RESIDENT_PHONE_NUMBER"]
  end

  def default_response
    <<-EOS
    <Response>
      <Say voice='man' language='en'></Say>
      <Sms from='#{twilio_virtual_number}' to='#{resident_number}'>Guest arrived @ 1761 Vallejo St.</Sms>
      <Play digits='9'></Play>
      <Hangup/>
    </Response>
    EOS
  end

  def landlord_home_response
    <<-EOS
    <Response>
      <Dial callerId='#{twilio_virtual_number}'>#{resident_number}</Dial>
    </Response>
    EOS
  end

  def toggle_landlord_response
    <<-EOS
    <Response>
      <Sms from='#{twilio_virtual_number}' to='#{resident_number}'>#{toggle_landlord_success_message}</Sms>
    </Response>
    EOS
  end

  def toggle_landlord_success_message
    if landlord_home?
      msg = "You will get forwarded calls to let guests in."
    else
      msg = "Guests will automagically be let in! You will be texted when they arrive."
    end

    "Switched landlord home! #{msg}"
  end
end
