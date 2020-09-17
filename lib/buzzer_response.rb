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

  def from_number
    ENV["TWILIO_PHONE_NUMBER"]
  end

  # Allows for CSV separate phone numbers (if multiple).
  def to_numbers
    @to_numbers ||= ENV["TO_PHONE_NUMBER"].split(",").each(&:strip!)
  end

  def homie_roomie_number
    ENV["HOMIE_ROOMIE_NUMBER"]
  end

  def toggle_landlord
    landlord_home = landlord_home?
    $redis.set(!landlord_home)

    response = Twilio::TwiML::VoiceResponse.new
    to_numbers.each do |n|
      response.sms(to: n, from: from_number, message: "🆕 Updated auto-buzz: #{!landlord_home}.\n - (#{phone_number})")
    end

    response.to_s
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
  def default_response
    response = Twilio::TwiML::VoiceResponse.new

    to_numbers.each { |n| response.sms(to: n, from: from_number, message: "👋 #{who_dis} - [#{current_time}]") }
    response.play(digits: "9")
    response.hangup

    response.to_s
  end

  def landlord_home_response
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.dial(caller_id: from_number, number: phone_number)
    end
  end
end
