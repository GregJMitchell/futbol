require './test/test_helper'
require './lib/team'

class TeamTest < Minitest::Test
  def setup
    @row = ["1", "23", "Atlanta United", "ATL", "Mercedes-Benz Stadium", "/api/v1/teams/1"]
    @team = Team.new(@row)
  end

  def test_it_has_attributes
    assert_equal 1, @team.team_id
    assert_equal 23, @team.franchise_id
    assert_equal 'Atlanta United', @team.team_name
    assert_equal 'ATL', @team.abbreviation
    assert_equal 'Mercedes-Benz Stadium', @team.stadium
    assert_equal '/api/v1/teams/1', @team.link
  end
end
