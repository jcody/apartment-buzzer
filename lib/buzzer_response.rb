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
    return $redis.get(phone_number) if $redis.exists?(phone_number)

    ENV["LANDLORD_HOME"] == "true"
  end

  def caller_id_number
    ENV["TWILIO_PHONE_NUMBER"]
  end

  # Allows for CSV separate phone numbers (if multiple).
  def resident_numbers
    @resident_numbers ||= ENV["TO_PHONE_NUMBER"].split(",").each(&:strip!)
  end

  def homie_roomie_number
    ENV["HOMIE_ROOMIE_NUMBER"]
  end

  def toggle_landlord
    landlord_home = $redis.get(phone_number) || false

    $redis.set(!landlord_home)
  end

  private

  def current_time
    TZInfo::Timezone.get(tz).to_local(Time.now).strftime("%-l:%M %P")
  end

  def tz
    ENV.fetch("TIMEZONE") { "America/Los_Angeles" }
  end

  def who_dis
    ENV.fetch("GREETING") { "Arrived!" }
  end

  # Press '9' to open front door at my aparment.
  # Change this if yours is different. Can also `<Say></Say>` greetings to guests (check Twilio docs).
  # My neighbors did not like the `<Say></Say>` ¯\_(ツ)_/¯.
  def default_response
    <<-EOS
    <Response>
      <Say voice='man' language='en'></Say>

      <Play digits='9'></Play>
      <Hangup/>
    </Response>
    EOS
  end

  def sms_greeting
    resident_numbers.each do |number|
      <<-GREETING
        <Sms from='#{caller_id_number}' to='#{resident_number}'>👋 #{who_dis} - [#{current_time}]</Sms>
      GREETING
    end
  end

  def landlord_home_response
    <<-EOS
    <Response>
      <Dial callerId='#{caller_id_number}'>#{phone_number}</Dial>
    </Response>
    EOS
  end
end
