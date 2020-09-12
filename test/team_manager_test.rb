require './test/test_helper'
require './lib/team_manager'

class TeamManagerTest < Minitest::Test
  # def test_it_has_attributes
  # end

  def test_it_can_find_a_team_and_get_its_info
    team1 = mock('team 1')
    team1.stubs(:team_id).returns('1')
    team1.stubs(:team_info).returns('team1 info hash')
    team2 = mock('team 2')
    team2.stubs(:team_id).returns('2')
    team2.stubs(:team_info).returns('team2 info hash')
    team3 = mock('team 3')
    team3.stubs(:team_id).returns('3')
    team3.stubs(:team_info).returns('team3 info hash')
    team_array = [team1, team2, team3]
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new("A totally legit path", "A totally legit stat_tracker")
    team_manager.stubs(:teams).returns(team_array)

    assert_equal team1.team_info, team_manager.team_info('1')
    assert_equal team2.team_info, team_manager.team_info('2')
    assert_equal team3.team_info, team_manager.team_info('3')    
  end
end
