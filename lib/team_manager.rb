require_relative 'team'
require_relative 'csv_module'
require 'csv'

class TeamManager
  include CSVModule
  attr_reader :teams, :teams_data
  def initialize(locations, stat_tracker)
    @stat_tracker = stat_tracker
    @teams = generate_teams(locations[:teams])
    @teams_data = team_data_by_id
  end

  def team_info(team_id)
    teams_data[team_id]
  end

  def team_data_by_id
    @teams.map{|team| [team.team_id, team.team_info]}.to_h
  end

  def count_of_teams
    @teams_data.count
  end
end
