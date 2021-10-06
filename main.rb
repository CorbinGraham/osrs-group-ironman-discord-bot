require 'discordrb'
require_relative './hiscores_parser.rb'

API_KEY = '<token here>'
TIMEOUT_SECONDS = 300

@last_update_time = Time.now() - TIMEOUT_SECONDS
@data = nil

bot = Discordrb::Bot.new token: API_KEY

bot.message(with_text: '!update') do |event|
    time_span = Time.now() - @last_update_time
    if (time_span) < TIMEOUT_SECONDS
        event.respond("Hold up! Wait #{TIMEOUT_SECONDS - time_span} more seconds...")
    else
        event.respond("Updating...")
        parse_hiscores_page()
        @last_update_time = Time.now()
# end

while true
    time_span = Time.now() - @last_update_time
    if (time_span) < TIMEOUT_SECONDS
        puts("Hold up! Wait #{TIMEOUT_SECONDS - time_span} more seconds...")
    else
        puts("updating...")
        @last_update_time = Time.now()
    end
end

# bot.run