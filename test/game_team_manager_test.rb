require './test/test_helper'
require './lib/game_team_manager'
require './lib/stat_tracker'

class GameTeamManagerTest < Minitest::Test
  def setup
    @game_path = './data/games.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './fixtures/fixture_game_teams.csv'

    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }
    @stat_tracker = mock('stat tracker object')
    @game_team_manager = GameTeamManager.new(@locations[:game_teams], @stat_tracker)
  end

  def test_score_average_per_team
    stat_tracker = mock('stat tracker object')
    game_teams_manager = GameTeamManager.new(@locations[:game_teams], stat_tracker)
    expected = 2.39
    assert_equal expected, game_teams_manager.goal_avg_per_team('5', '')
    expected = 2.25
    assert_equal expected, game_teams_manager.goal_avg_per_team('5', 'home')
    expected = 2.5
    assert_equal expected, game_teams_manager.goal_avg_per_team('5', 'away')
  end

  def test_with_best_offense
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "DC United", stat_tracker.best_offense
  end

  def test_with_worst_offense
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "Houston Dash", stat_tracker.worst_offense
  end

  def test_highest_scoring_visitor
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "New England Revolution", stat_tracker.highest_scoring_visitor
  end

  def test_highest_scoring_home_team
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "DC United", stat_tracker.highest_scoring_home_team
  end

  def test_lowest_scoring_visitor
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "New York City FC", stat_tracker.lowest_scoring_visitor
  end

  def test_lowest_scoring_home_team
    stat_tracker = StatTracker.from_csv(@locations)

    assert_equal "Seattle Sounders FC", stat_tracker.lowest_scoring_home_team
  end

  def test_it_exists
    stat_tracker = mock('stat tracker')
    game_team_manager = GameTeamManager.new(@locations[:game_teams], stat_tracker)
    assert_instance_of GameTeamManager, game_team_manager
  end

  def test_can_get_game_team_info

    assert_equal 585, @game_team_manager.game_teams.count
  end

  def test_game_teams_data_for_season

    assert_equal 498, @game_team_manager.game_teams_data_for_season('20122013').length
    assert_equal '2012020006', @game_team_manager.game_teams_data_for_season('20122013')[0].game_id
    assert_equal 'Claude Noel', @game_team_manager.game_teams_data_for_season('20122013')[-1].head_coach
  end

  def test_season_coaches
    expected_1 = ["Peter DeBoer", "Jack Capuano", "John Tortorella"]
    expected_2 = ["Todd Richards", "Mike Yeo", "Claude Noel"]

    assert_equal 32, @game_team_manager.season_coaches('20122013').length
    assert_equal expected_1, @game_team_manager.season_coaches('20122013')[0..2]
    assert_equal expected_2, @game_team_manager.season_coaches('20122013')[-3..-1]
  end

  def test_winningest_coach

    assert_equal 'Joel Quenneville', @game_team_manager.winningest_coach('20122013')
  end

  def test_worst_coach

    assert_equal 'Ron Rolston', @game_team_manager.worst_coach('20122013')
  end

  def test_coaches_by_win_percentage

    assert_equal 52.94, @game_team_manager.coaches_by_win_percentage('20122013','Peter DeBoer')
    assert_equal 29.41, @game_team_manager.coaches_by_win_percentage('20122013','Ken Hitchcock')
  end

  def test_total_shots_by_team

    assert_equal 123, @game_team_manager.total_shots_by_team('20122013', '16')
    assert_equal 106, @game_team_manager.total_shots_by_team('20122013', '15')
  end

  def test_total_goals_by_team

    assert_equal 45, @game_team_manager.total_goals_by_team('20122013', '16')
    assert_equal 37, @game_team_manager.total_goals_by_team('20122013', '19')
  end

  def test_season_teams
    expected = 30
    assert_equal 30, @game_team_manager.season_teams('20122013').length
    assert_equal expected, @game_team_manager.season_teams('20122013').count
  end

  def test_team_accuracy

    assert_equal 0.365854, @game_team_manager.team_accuracy('20122013')['16']
    assert_equal 0.316239, @game_team_manager.team_accuracy('20122013')['19']
  end

  def test_most_accurate_team

    game_team_manager = GameTeamManager.new(@locations[:game_teams], @stat_tracker)
    assert_equal '14', game_team_manager.most_accurate_team('20122013')
  end

  def test_least_accurate_team

    game_team_manager = GameTeamManager.new(@locations[:game_teams], @stat_tracker)
    assert_equal '9', game_team_manager.least_accurate_team('20122013')
  end

  def test_most_tackles

    game_team_manager = GameTeamManager.new(@locations[:game_teams], @stat_tracker)
    assert_equal '10', game_team_manager.most_tackles('20122013')
  end

  def test_fewest_tackles

    game_team_manager = GameTeamManager.new(@locations[:game_teams], @stat_tracker)
    assert_equal '16', game_team_manager.fewest_tackles('20122013')
  end

  def test_it_can_fetch_game_ids_for_a_team
    game_team1 = mock('game_team 1')
    game_team1.stubs(:game_id).returns('1')
    game_team1.stubs(:team_id).returns('1')
    game_team2 = mock('game_team 2')
    game_team2.stubs(:game_id).returns('2')
    game_team2.stubs(:team_id).returns('1')
    game_team3 = mock('game_team 3')
    game_team3.stubs(:game_id).returns('3')
    game_team3.stubs(:team_id).returns('2')
    stat_tracker = mock('A totally legit stat_tracker')
    game_team_array = [game_team1, game_team2, game_team3]
    CSV.stubs(:foreach).returns(nil)
    game_team_manager = GameTeamManager.new('A totally legit path', stat_tracker)
    game_team_manager.stubs(:game_teams).returns(game_team_array)

    assert_equal ['1', '2'], game_team_manager.game_ids_by_team('1')
    assert_equal ['3'], game_team_manager.game_ids_by_team('2')
  end

  def test_it_can_fetch_game_team_info
    game_team1 = mock('game_team 1')
    game_team1.stubs(:game_id).returns('1')
    game_team1.stubs(:team_id).returns('1')
    game_team1.stubs(:game_team_info).returns('game_team1 info')
    game_team2 = mock('game_team 2')
    game_team2.stubs(:game_id).returns('2')
    game_team2.stubs(:team_id).returns('1')
    game_team3 = mock('game_team 3')
    game_team3.stubs(:game_id).returns('3')
    game_team3.stubs(:team_id).returns('2')
    game_team4 = mock('game_team 4')
    game_team4.stubs(:game_id).returns('1')
    game_team4.stubs(:game_team_info).returns('game_team4 info')
    game_team4.stubs(:team_id).returns('2')
    stat_tracker = mock('A totally legit stat_tracker')
    game_team_array = [game_team1, game_team2, game_team3, game_team4]
    CSV.stubs(:foreach).returns(nil)
    game_team_manager = GameTeamManager.new('A totally legit path', stat_tracker)
    game_team_manager.stubs(:game_teams).returns(game_team_array)

    expected = {
        '1' => 'game_team1 info',
        '2' => 'game_team4 info'
    }
    assert_equal expected, game_team_manager.game_team_info('1')
  end
end
