require './test/test_helper'
require './lib/game_teams'

class GameTeamsTest < Minitest::Test

  def setup
    @row = { 'game_id' => '2012030221', 'team_id' => '3', 'HoA' => 'away',
           'result' => 'LOSS', 'settled_in' => 'OT', 'head_coach' => 'John Tortorella',
           'goals' => '2', 'shots' => '8', 'tackles' => '44', 'pim' => '8',
           'powerPlayOpportunities' => '3', 'powerPlayGoals' => '0',
           'faceOffWinPercentage' => '44.8', 'giveaways' => '17', 'takeaways' => '7' }
  end

  def test_has_attributes
    game = GameTeams.new(@row)
    assert_equal '2012030221', game.game_id
    assert_equal '3', game.team_id
    assert_equal 'away', game.hoa
    assert_equal 'LOSS', game.result
    assert_equal 'OT', game.settled_in
    assert_equal 'John Tortorella', game.head_coach
    assert_equal 2, game.goals
    assert_equal 8, game.shots
    assert_equal 44, game.tackles
    assert_equal 8, game.pim
    assert_equal 3, game.power_play_opportunities
    assert_equal 0, game.power_play_goals
    assert_equal 44.8, game.face_off_win_percentage
    assert_equal 17, game.giveaways
    assert_equal 7, game.takeaways
  end

  def test_it_can_get_game_team_info
    game_team = GameTeams.new(@row)
    expected = {
      game_id: '2012030221',
      team_id: '3',
      hoa: 'away',
      result: 'LOSS',
      head_coach: 'John Tortorella',
      goals: 2
    }

    assert_equal expected, game_team.game_team_info
  end
end
