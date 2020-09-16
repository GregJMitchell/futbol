require './test/test_helper'
require './lib/stat_tracker'
require 'pry'

class TestStatTracker < Minitest::Test
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

  def test_it_can_get_team_data
    locations =  {
      games: './fixtures/fixture_games.csv',
      teams: './fixtures/teams_init_test.csv',
      game_teams: './fixtures/fixture_game_teams.csv'
    }
    stat_tracker = StatTracker.from_csv(locations)
    expected = {
      'team_id' => 't1',
      'franchise_id' => 'f1',
      'team_name' => 'n1',
      'abbreviation' => 'a1',
      'link' => 'l1'
    }
    actual = stat_tracker.team_info('t1')

    assert_equal expected, actual
  end

  def test_it_can_fetch_game_ids_for_a_team
    locations =  {
      games: './fixtures/fixture_games.csv',
      teams: './fixtures/teams_init_test.csv',
      game_teams: './fixtures/fixture_game_teams.csv'
    }
    stat_tracker = StatTracker.new(locations)
    expected = 17

    assert_equal expected, stat_tracker.game_ids_by_team('17').length
  end

  def test_it_can_fetch_game_team_info
    locations =  {
      games: './fixtures/fixture_games.csv',
      teams: './fixtures/teams_init_test.csv',
      game_teams: './fixtures/fixture_game_teams.csv'
    }
    stat_tracker = StatTracker.new(locations)
    info16 = stat_tracker.game_team_manager.game_teams[15].game_team_info
    info17 = stat_tracker.game_team_manager.game_teams[152].game_team_info
    expected = {
      '1' => info16,
      '9' => info17
    }

    assert_equal expected, stat_tracker.game_team_info('2012020219')
  end

  def test_it_can_fetch_game_info
    locations =  {
      games: './fixtures/fixture_games.csv',
      teams: './fixtures/teams_init_test.csv',
      game_teams: './fixtures/fixture_game_teams.csv'
    }
    stat_tracker = StatTracker.new(locations)
    expected = {
      season_id: '20142015',
      game_id: '2014021174',
      home_team_id: '3',
      away_team_id: '1',
      home_goals: 4,
      away_goals: 1
    }

    assert_equal expected, stat_tracker.game_info('2014021174')
  end

  def test_it_can_calculate_average_win_percentage_for_a_team
    locations =  {
      games: './fixtures/team_stats_fixture_games.csv',
      teams: './data/teams.csv',
      game_teams: './fixtures/team_stats_fixture_game_teams.csv'
    }
    stat_tracker = StatTracker.new(locations)

    assert_equal 0.56, stat_tracker.average_win_percentage('26')
    assert_equal 0.45, stat_tracker.average_win_percentage('24')
  end

  def test_it_can_find_a_teams_favorite_opponent
    locations =  {
      games: './fixtures/team_stats_fixture_games.csv',
      teams: './data/teams.csv',
      game_teams: './fixtures/team_stats_fixture_game_teams.csv'
    }
    stat_tracker = StatTracker.new(locations)

    assert_equal 'Chicago Fire', stat_tracker.favorite_opponent('24')
  end

  def test_it_can_find_a_teams_rival
    locations =  {
      games: './fixtures/team_stats_fixture_games.csv',
      teams: './data/teams.csv',
      game_teams: './fixtures/team_stats_fixture_game_teams.csv'
    }
    stat_tracker = StatTracker.new(locations)

    assert_equal 'North Carolina Courage', stat_tracker.rival('24')
  end

  def test_it_can_find_most_goals_scored_by_team
    locations =  {
      games: './fixtures/team_stats_fixture_games.csv',
      teams: './data/teams.csv',
      game_teams: './fixtures/team_stats_fixture_game_teams.csv'
    }
    stat_tracker = StatTracker.new(locations)

    assert_equal 4, stat_tracker.most_goals_scored('24')
  end

  def test_it_can_find_fewest_goals_scored_by_team
    locations =  {
      games: './fixtures/team_stats_fixture_games.csv',
      teams: './data/teams.csv',
      game_teams: './fixtures/team_stats_fixture_game_teams.csv'
    }
    stat_tracker = StatTracker.new(locations)

    assert_equal 0, stat_tracker.fewest_goals_scored('24')
  end

  def test_it_can_find_a_teams_best_season
    locations =  {
      games: './fixtures/team_stats_fixture_games.csv',
      teams: './data/teams.csv',
      game_teams: './fixtures/team_stats_fixture_game_teams.csv'
    }
    stat_tracker = StatTracker.new(locations)

    assert_equal '20122013', stat_tracker.best_season('24')
  end

  def test_it_can_find_a_teams_worst_season
    locations =  {
      games: './fixtures/team_stats_fixture_games.csv',
      teams: './data/teams.csv',
      game_teams: './fixtures/team_stats_fixture_game_teams.csv'
    }
    stat_tracker = StatTracker.new(locations)

    assert_equal '20132014', stat_tracker.worst_season('24')
  end

  def test_it_can_find_highest_total_score
    assert_equal 11, @stat_tracker.highest_total_score
  end

  def test_it_can_find_lowest_total_score
    assert_equal 0, @stat_tracker.lowest_total_score
  end

  def test_it_can_find_percentage_home_wins
    assert_equal 0.44, @stat_tracker.percentage_home_wins
  end

  def test_it_can_find_percentage_visitor_wins
    assert_equal 0.36, @stat_tracker.percentage_visitor_wins
  end

  def test_it_can_find_percentage_ties
    assert_equal 0.20, @stat_tracker.percentage_ties
  end

  def test_it_can_find_count_of_games_by_season
    assert_equal 1323, @stat_tracker.count_of_games_by_season['20132014']
    assert_equal 1319, @stat_tracker.count_of_games_by_season['20142015']
    assert_equal 1321, @stat_tracker.count_of_games_by_season['20152016']
  end

  def test_it_can_find_average_goals_per_game
    assert_equal 4.22, @stat_tracker.average_goals_per_game
  end

  def test_it_can_find_average_goals_by_season
    assert_equal 4.12, @stat_tracker.average_goals_by_season['20122013']
    assert_equal 4.23, @stat_tracker.average_goals_by_season['20162017']
    assert_equal 4.14, @stat_tracker.average_goals_by_season['20142015']
  end

  def test_it_can_find_winningest_coach
    assert_equal "Dan Lacroix", @stat_tracker.winningest_coach('20122013')
    assert_equal "Alain Vigneault", @stat_tracker.winningest_coach('20142015')
    assert_equal "Bruce Cassidy", @stat_tracker.winningest_coach('20162017')
  end

  def test_it_can_find_worst_coach
    assert_equal "Martin Raymond", @stat_tracker.worst_coach('20122013')
    assert_equal "Ted Nolan", @stat_tracker.worst_coach('20142015')
    assert_equal "Dave Tippett", @stat_tracker.worst_coach('20162017')
  end

  def test_it_can_find_most_accurate_team
    assert_equal "Real Salt Lake", @stat_tracker.most_accurate_team('20132014')
    assert_equal "Toronto FC", @stat_tracker.most_accurate_team('20142015')
    assert_equal "Portland Thorns FC", @stat_tracker.most_accurate_team('20162017')
  end

  def test_it_can_find_least_accurate_team
    assert_equal "New York City FC", @stat_tracker.least_accurate_team('20132014')
    assert_equal "Columbus Crew SC", @stat_tracker.least_accurate_team('20142015')
    assert_equal "FC Cincinnati", @stat_tracker.least_accurate_team('20162017')
  end

  def test_it_can_find_most_tackles
    assert_equal "FC Cincinnati", @stat_tracker.most_tackles('20132014')
    assert_equal "Seattle Sounders FC", @stat_tracker.most_tackles('20142015')
    assert_equal "Sporting Kansas City", @stat_tracker.most_tackles('20162017')
  end

  def test_it_can_find_fewest_tackles
    assert_equal "Atlanta United", @stat_tracker.fewest_tackles('20132014')
    assert_equal "Orlando City SC", @stat_tracker.fewest_tackles('20142015')
    assert_equal "New England Revolution", @stat_tracker.fewest_tackles('20162017')
  end

  def test_it_can_find_team_data
    assert_equal 32, @stat_tracker.team_data.count

    expected = {"team_id"=>"1", "franchise_id"=>"23", "team_name"=>"Atlanta United", "abbreviation"=>"ATL", "link"=>"/api/v1/teams/1"}

    assert_equal expected, @stat_tracker.team_data['1']
  end

  def test_it_can_count_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end
end
