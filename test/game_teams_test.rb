require './test/test_helper'
require './lib/game_teams'


class GameTeamsTest < Minitest::Test

  def setup
    @row = {game_id: '2012030221', team_id: '3',HoA: 'away',
           result: 'LOSS',settled_in: 'OT', head_coach: 'John Tortorella',
           goals: '2',shots: '8',tackles: '44',pim: '8',
           powerPlayOpportunities: '3', powerPlayGoals: '0',
           faceOffWinPercentage: '44.8', giveaways: '17', takeaways:'7'}
  end

  def test_has_attributes
    game = GameTeams.new(@row)
    assert_equal '2012030221', game.game_id
    assert_equal '3', game.team_id
    assert_equal 'away', game.HoA
    assert_equal 'LOSS', game.result
    assert_equal 'OT', game.settled_in
    assert_equal 'John Tortorella', game.head_coach
    assert_equal 2, game.goals
    assert_equal 8, game.shots
    assert_equal 44, game.tackles
    assert_equal 8, game.pim
    assert_equal 3, game.powerPlayOpportunities
    assert_equal 0, game.powerPlayGoals
    assert_equal 44.8, game.faceOffWinPercentage
    assert_equal 17, game.giveaways
    assert_equal 7, game.takeaways
  end
end
