require 'net/http'
require 'erb'

def fetch_hiscores_page(group_name)
  # Initial Variables for fetching
  base_URL = "https://secure.runescape.com/m=hiscore_oldschool_ironman/group-ironman/view-group?name="
  full_URI_path = ("#{base_URL}#{ERB::Util.url_encode(group_name)}")

  uri = URI(full_URI_path)
  Net::HTTP.get(uri)
end
