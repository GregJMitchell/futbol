require './test/test_helper'
require './lib/stat_tracker'
require 'csv_module'
require 'pry'



class TestStatTracker <Minitest::Test

  def setup
    @game_path = './data/games.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams.csv'
    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(@locations)
  end

  def test_stat_tracker_can_pull_file_locations

    assert_equal 7441, @stat_tracker.game_manager.games.length
    assert_equal 32, @stat_tracker.team_manager.teams.length
    assert_equal 14882, @stat_tracker.game_team_manager.game_teams.length
  end

  def test_


  end
end
