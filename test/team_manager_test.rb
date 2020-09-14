require './test/test_helper'
require './lib/team_manager'


class TeamManagerTest < Minitest::Test

  def setup
    @game_path = './data/games.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams.csv'
    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }
    @team_manager = TeamManager.new(@locations, @stat_tracker)
    @team_manager.generate_teams(@locations[:teams])
  end

  # def test_team_info
  #
  #   assert_equal "New England Revolution", @team_manager.team_info("16")["team_name"]
  # end
end
