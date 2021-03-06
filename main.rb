require 'discordrb'
require_relative './lib/hiscores_parser.rb'

API_KEY = ENV['DISCORD_API_KEY']
TIMEOUT_SECONDS = 300
GROUP_NAME = 'Pen Boys'

@last_update_time = Time.now() - TIMEOUT_SECONDS
# Map array, [0] is group_map, [1] is player_map
@group_map = nil
@individual_map = nil

bot = Discordrb::Bot.new token: API_KEY

bot.message(with_text: '!update') do |event|
    time_span = Time.now() - @last_update_time
    if (time_span) < TIMEOUT_SECONDS
        event.respond("Hold up! Wait #{TIMEOUT_SECONDS - time_span} more seconds...")
    else
        response = parse_hiscores_page()
        @group_map = response[0]
        @individual_map = response[1]
        @last_update_time = Time.now()
        event.respond("Updated!")
    end
end

bot.message(with_text: '!group') do |event|
    response = %{
        Group: **#{GROUP_NAME}**
    }

    @group_map.each do |grouping_type, stats|
      stats.each do |skill, value|
        response += "\n#{skill}: \t**#{value} XP**"
      end
    end

    event.respond(response)
end

bot.message(with_text: '!contrib') do |event|
    total_exp = @group_map["Total contribution XP"]["Group_totals"].to_f

    response = "\nTotal group xp: **#{total_exp} XP**"

    @individual_map.each do |username, stats|
        personal_exp = stats["Account_totals"][1]
        percentage = (personal_exp / total_exp)*100
        puts(personal_exp, total_exp, percentage)
        response += "\n#{username}: \t**#{personal_exp} XP** \t(*#{'%.2f' % percentage}%*)"
    end

    event.respond(response)
end

bot.run
