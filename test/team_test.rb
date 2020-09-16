require './test/test_helper'
require './lib/team'

class TeamTest < Minitest::Test
  def setup
    @row = {
      'team_id' => '1',
      'franchiseId' => '23',
      'teamName' => 'Atlanta United',
      'abbreviation' => 'ATL',
      'Stadium' => 'Mercedes-Benz Stadium',
      'link' => '/api/v1/teams/1'
    }
    @team = Team.new(@row)
  end

  def test_it_has_attributes

    assert_equal '1', @team.team_id
    assert_equal '23', @team.franchise_id
    assert_equal '1', @team.team_id
    assert_equal '23', @team.franchise_id
    assert_equal 'Atlanta United', @team.team_name
    assert_equal 'ATL', @team.abbreviation
    assert_equal 'Mercedes-Benz Stadium', @team.stadium
    assert_equal '/api/v1/teams/1', @team.link
  end

  def test_it_can_generate_team_info
    expected = {
      'team_id' => '1',
      'franchise_id' => '23',
      'team_name' => 'Atlanta United',
      'abbreviation' => 'ATL',
      'link' => '/api/v1/teams/1'
    }
    actual = @team.team_info

    assert_equal expected, actual
  end
end
