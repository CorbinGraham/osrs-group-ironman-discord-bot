require 'net/http'
require 'erb'

# Initial Variables for fetching
base_URL = "https://secure.runescape.com/m=hiscore_oldschool_ironman/group-ironman/view-group?name="
group_name = ERB::Util.url_encode("pen boys")
full_URI_path = "#{base_URL}#{group_name}"

uri = URI(full_URI_path)
results = Net::HTTP.get(uri)
puts(results)