require './test/test_helper'
require './lib/game'


class GameTest <Minitest::Test
  def setup
    @row = {game_id: '2012030221', season: '20122013', type: 'Postseason',
      date_time: '5/16/13', away_team_id: '3', home_team_id:'6', away_goals: '2',
      home_goals: '3', venue: 'Toyota Stadium', venue_link: '/api/v1/venues/null'}
  end

  def test_has_attributes
    game = Game.new(@row)
    assert_equal'2012030221', game.game_id
    assert_equal '20122013', game.season
    assert_equal'Postseason', game.type
    assert_equal '5/16/13', game.date_time
    assert_equal '3', game.away_team_id
    assert_equal '6', game.home_team_id
    assert_equal 2, game.away_goals
    assert_equal 3, game.home_goals
    assert_equal 'Toyota Stadium', game.venue
    assert_equal '/api/v1/venues/null', game.venue_link
  end

  def test_it_can_generate_game_info
    game = Game.new(@row)
    expected = {
      season_id: '20122013',
      game_id: '2012030221',
      home_team_id: '6',
      away_team_id: '3',
      home_goals: 3,
      away_goals: 2
    }

    assert_equal expected, game.game_info
  end
end
