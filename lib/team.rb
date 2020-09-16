class Team
  attr_reader :team_id, :franchise_id, :team_name, :abbreviation, :stadium, :link
  def initialize(row)
    @team_id = row['team_id']
    @franchise_id = row['franchiseId']
    @team_name = row['teamName']
    @abbreviation = row['abbreviation']
    @stadium = row['Stadium']
    @link = row['link']
  end

  def team_info
    team_hash = {}
    team_hash['team_id'] = team_id
    team_hash['franchise_id'] = franchise_id
    team_hash['team_name'] = team_name
    team_hash['abbreviation'] = abbreviation
    team_hash['link'] = link

    team_hash
  end
end
