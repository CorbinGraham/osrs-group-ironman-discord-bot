require 'nokogiri'
require_relative './http_fetcher.rb'

@group_name = 'pen boys'
@accepted_skills = %w[
  Attack
  Defence
  Strength
  Hitpoints
  Ranged
  Prayer
  Magic
  Cooking
  Woodcutting
  Fletching
  Fishing
  Firemaking
  Crafting
  Smithing
  Mining
  Herblore
  Agility
  Thieving
  Slayer
  Farming
  Runecraft
  Hunter
  Construction
].freeze

# Uses the http_fetcher to grab the hiscores page then parses it into a JSON.
def parse_hiscores_page()
  doc = Nokogiri::HTML(fetch_hiscores_page(@group_name))
  group_hiscores_map = extract_group_hiscores(doc)
  puts(group_hiscores_map)
  individual_hiscores_map = extract_individual_hiscores(doc)
end

# Input is the entire page CSS
# Output is a map of all of our group hiscores
# Format is {{"Size"=>"5"}
#            {"Total level"=>"772"}
#              ...}
def extract_group_hiscores(doc)
  group_block = doc.css('dl.um-detail-list')

  scores = group_block.css('dd')
  group_block.css('dt').each_with_index.map { |node, index| {
    node.text.gsub("Expand","").strip => scores[index].text.strip }
  }
end

def extract_individual_hiscores(doc)
  individual_block = doc.css('table.uc-scroll__table')
  scores = individual_block.css('tr')

  cleaned_scores = []
  # Strips out all of the bad text and newlines
  scores.each do |score|
     # Returns 3 values [skill, level, exp] with lots of whitespace infront
     dirty_score_array = score.text.split("\n").reject {|item| item.strip == '' || item.strip == 'Expand' }
     cleaned_scores << dirty_score_array.map { |item| item.strip }
  end

  # Removes the first element since we don't want it.
  cleaned_scores.shift

  # Outputs a Hash map in the following format
  # { Username => {
  #                 skill => [level, exp]
  #               }
  # }
  individual_scores_map = {}
  current_username = ""
  cleaned_scores.each do |score_array|
    # Checks to see if we are looking at a username or at a hiscore
    if @accepted_skills.include?(score_array[0])
      individual_scores_map[current_username][score_array[0]] = [score_array[1].delete(',').to_i, score_array[2].delete(',').to_i]
    else
      current_username = score_array[0]
      individual_scores_map[current_username] = {"Account_totals" => [score_array[1].delete(',').to_i, score_array[2].delete(',').to_i] }
    end
  end
  individual_scores_map
end

parse_hiscores_page()
