require './test/test_helper'
require './lib/game_team_manager'

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
    @stat_tracker = mock('stat tracker')
    @game_team_manager = GameTeamManager.new(@locations, @stat_tracker)
  end

  def test_it_exists

    assert_instance_of GameTeamManager, @game_team_manager
  end

  def test_can_get_game_team_info

    assert_equal 80, @game_team_manager.game_teams.count
  end

  def test_game_teams_data_for_season

    assert_equal 29, @game_team_manager.game_teams_data_for_season('20122013').length
    assert_equal '2012030221', @game_team_manager.game_teams_data_for_season('20122013')[0].game_id
    assert_equal 'Joel Quenneville', @game_team_manager.game_teams_data_for_season('20122013')[-1].head_coach
  end

  def test_season_coaches
    expected_1 = ['John Tortorella', 'Claude Julien', 'Dan Bylsma']
    expected_2 = ['Dan Bylsma', 'Mike Babcock', 'Joel Quenneville']

    assert_equal 5, @game_team_manager.season_coaches('20122013').length
    assert_equal expected_1, @game_team_manager.season_coaches('20122013')[0..2]
    assert_equal expected_2, @game_team_manager.season_coaches('20122013')[-3..-1]
  end

  def test_winningest_coach

    assert_equal 'Joel Quenneville', @game_team_manager.winningest_coach('20132014')
  end

  def test_worst_coach

    assert_equal 'Ken Hitchcock', @game_team_manager.worst_coach('20132014')
  end

  def test_coaches_by_win_percentage

    assert_equal 2, @game_team_manager.coaches_by_win_percentage('20132014').length
    assert_equal 20.0, @game_team_manager.coaches_by_win_percentage('20132014')['Ken Hitchcock']
  end

  def test_total_shots_by_team

    assert_equal 38, @game_team_manager.total_shots_by_team('20132014', '16')
    assert_equal 0, @game_team_manager.total_shots_by_team('20132014', '15')
  end

  def test_total_goals_by_team

    assert_equal 13, @game_team_manager.total_goals_by_team('20132014', '16')
    assert_equal 9, @game_team_manager.total_goals_by_team('20132014', '19')
  end

  def test_season_teams
    expected = ['16', '19']
    assert_equal 2, @game_team_manager.season_teams('20132014').length
    assert_equal expected, @game_team_manager.season_teams('20132014')
  end

  def test_team_accuracy

    assert_equal 0.342105, @game_team_manager.team_accuracy('20132014')['16']
    assert_equal 0.209302, @game_team_manager.team_accuracy('20132014')['19']
  end

  def test_most_accurate_team

    game_team_manager = GameTeamManager.new(@locations, @stat_tracker)
    game_team_manager.stubs(:team_by_id).returns('This team')
    assert_equal 'This team', game_team_manager.most_accurate_team('20132014')
  end

  def test_least_accurate_team

    game_team_manager = GameTeamManager.new(@locations, @stat_tracker)
    game_team_manager.stubs(:team_by_id).returns('This team')
    assert_equal 'This team', game_team_manager.least_accurate_team('20132014')
  end

  def test_most_tackles

    game_team_manager = GameTeamManager.new(@locations, @stat_tracker)
    game_team_manager.stubs(:team_by_id).returns('This team')
    assert_equal 'This team', game_team_manager.most_tackles('20132014')
  end

  def test_fewest_tackles

    game_team_manager = GameTeamManager.new(@locations, @stat_tracker)
    game_team_manager.stubs(:team_by_id).returns('This team')
    assert_equal 'This team', game_team_manager.fewest_tackles('20132014')
  end

  def test_team_by_id

    game_team_manager = GameTeamManager.new(@locations, @stat_tracker)
    team_1 = mock('team_1')
    game_team_manager.stubs(:team_by_id).returns('This team')
    assert_equal 'This team', game_team_manager.team_by_id(team_1)
  end
end
