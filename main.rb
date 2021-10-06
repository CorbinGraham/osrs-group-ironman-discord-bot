# require 'discordrb'

API_KEY = '<token here>'
@last_update_time = Time.now() - 5

# bot = Discordrb::Bot.new token: API_KEY

# bot.message(with_text: '!update') do |event|
#  event.respond 
# end

while true
    gets
    time_span = Time.now() - @last_update_time
    if (time_span) < 5
        puts("Hold up! Wait #{time_span} more seconds...")
    else
        puts("updating...")
        @last_update_time = Time.now()
    end
end

# bot.run