require './test/test_helper'
require './lib/team_manager'
require './lib/stat_tracker'
require './lib/team'

class TeamManagerTest < Minitest::Test
  def setup
    @game_path = './data/games.csv'
    @team_path = './data/teams.csv'
    @game_teams_path = './data/game_teams.csv'
    @locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
    }
    @stat_tracker = mock('mock stat tracker')
    @team_manager = TeamManager.new(@locations[:teams], @stat_tracker)
  end

  def test_count_of_teams
    assert_equal 32, @team_manager.count_of_teams
  end

  def test_teams_names_data_pull
    # @team_manager = TeamManager.new(@locations, @team_manager)
    @team_manager.generate_data(@locations[:teams], Team)
    assert_equal 32, @team_manager.teams.count
  end

  def test_it_can_generate_team_objects
    stat_tracker = mock('A totally legit stat_tracker')
    team_manager = TeamManager.new('./fixtures/teams_init_test.csv', stat_tracker)
    counter = 1

    team_manager.teams.each do |team|
      assert_instance_of Team, team
      assert_equal "t#{counter}", team.team_id
      assert_equal "f#{counter}", team.franchise_id
      assert_equal "n#{counter}", team.team_name
      assert_equal "a#{counter}", team.abbreviation
      assert_equal "s#{counter}", team.stadium
      assert_equal "l#{counter}", team.link
      counter += 1
    end
  end

  def test_it_has_attributes
    stat_tracker = mock('A totally legit stat_tracker')
    CSV.stubs(:foreach).returns(nil)  # This causes generate_teams to return []
    team_manager = TeamManager.new('A totally legit path', stat_tracker)

    assert_equal stat_tracker, team_manager.stat_tracker
    assert_equal [], team_manager.teams
  end

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
    stat_tracker = mock('A totally legit stat_tracker')
    team_array = [team1, team2, team3]
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    team_manager.stubs(:teams).returns(team_array)

    assert_equal team1.team_info, team_manager.find_team('1').team_info
    assert_equal team2.team_info, team_manager.find_team('2').team_info
    assert_equal team3.team_info, team_manager.find_team('3').team_info
  end

  def test_it_can_fetch_game_ids_for_a_team
    stat_tracker = mock('A totally legit stat_tracker')
    stat_tracker.stubs(:game_ids_by_team).returns('An array of game ids')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)

    assert_equal 'An array of game ids', team_manager.game_ids_by_team('1')
  end

  def test_it_can_fetch_game_team_info
    stat_tracker = mock('A totally legit stat_tracker')
    stat_tracker.stubs(:game_team_info).returns('A hash of game teams')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)

    assert_equal 'A hash of game teams', team_manager.game_team_info('123')
  end

  def test_it_can_fetch_game_info
    stat_tracker = mock('A totally legit stat_tracker')
    stat_tracker.stubs(:game_info).returns('A hash of game info')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)

    assert_equal 'A hash of game info', team_manager.game_info('123')
  end

  def test_it_can_gather_all_game_team_info_for_a_team_id
    stat_tracker = mock('A totally legit stat_tracker')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    team_manager.stubs(:game_team_info).returns('A hash of game_team info')
    game_ids = ['2323232', '2323233']
    team_manager.stubs(:game_ids_by_team).returns(game_ids)
    expected = ['A hash of game_team info', 'A hash of game_team info']

    assert_equal expected, team_manager.gather_game_team_info('1')
  end

  def test_it_can_gather_all_game_info_for_a_team_id
    stat_tracker = mock('A totally legit stat_tracker')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    team_manager.stubs(:game_info).returns('A hash of game info')
    game_ids = ['2323232', '2323233']
    team_manager.stubs(:game_ids_by_team).returns(game_ids)
    expected = ['A hash of game info', 'A hash of game info']

    assert_equal expected, team_manager.gather_game_info('1')
  end

  def test_it_can_find_most_goals_scored_by_team
    stat_tracker = mock('A totally legit stat_tracker')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    game_team1 = {
      game_id: '2012030221',
      team_id: '3',
      hoa: 'away',
      result: 'LOSS',
      head_coach: 'John Tortorella',
      goals: 2
    }
    game_team2 = {
      game_id: '2012030221',
      team_id: '5',
      hoa: 'home',
      result: 'WIN',
      head_coach: 'A hamster',
      goals: 3
    }
    game_team3 = {
      game_id: '2012030275',
      team_id: '3',
      hoa: 'away',
      result: 'WIN',
      head_coach: 'John Tortorella',
      goals: 5
    }
    game_team4 = {
      game_id: '2012030275',
      team_id: '35',
      hoa: 'home',
      result: 'LOSS',
      head_coach: 'Martha Stewart',
      goals: 2
    }
    game_team_info1 = { '3' => game_team1, '5' => game_team2 }
    game_team_info2 = { '3' => game_team3, '35' => game_team4 }
    game_team_info = [game_team_info1, game_team_info2]
    team_manager.stubs(:gather_game_team_info).returns(game_team_info)

    assert_equal 5, team_manager.most_goals_scored('3')
  end

  def test_it_can_find_fewest_goals_scored_by_team
    stat_tracker = mock('A totally legit stat_tracker')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    game_team1 = {
      game_id: '2012030221',
      team_id: '3',
      hoa: 'away',
      result: 'LOSS',
      head_coach: 'John Tortorella',
      goals: 2
    }
    game_team2 = {
      game_id: '2012030221',
      team_id: '5',
      hoa: 'home',
      result: 'WIN',
      head_coach: 'A hamster',
      goals: 3
    }
    game_team3 = {
      game_id: '2012030275',
      team_id: '3',
      hoa: 'away',
      result: 'WIN',
      head_coach: 'John Tortorella',
      goals: 5
    }
    game_team4 = {
      game_id: '2012030275',
      team_id: '35',
      hoa: 'home',
      result: 'LOSS',
      head_coach: 'Martha Stewart',
      goals: 2
    }
    game_team_info1 = { '3' => game_team1, '5' => game_team2 }
    game_team_info2 = { '3' => game_team3, '35' => game_team4 }
    game_team_info = [game_team_info1, game_team_info2]
    team_manager.stubs(:gather_game_team_info).returns(game_team_info)

    assert_equal 2, team_manager.fewest_goals_scored('3')
  end

  def test_it_can_count_total_wins_for_a_team_or_opponent
    stat_tracker = mock('A totally legit stat_tracker')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    game1 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game2 = { '8' => { result: 'TIE' }, '5' => { result: 'TIE' } }
    game3 = { '5' => { result: 'WIN' }, '12' => { result: 'LOSS' } }
    game4 = { '5' => { result: 'WIN' }, '2' => { result: 'LOSS' } }
    game5 = { '5' => { result: 'WIN' }, '7' => { result: 'LOSS' } }
    game_teams_info = [game1, game2, game3, game4, game5]
    team_manager.stubs(:gather_game_team_info).returns(game_teams_info)

    assert_equal 3, team_manager.total_wins('5')
    assert_equal 1, team_manager.total_wins('6')
    assert_equal 0, team_manager.total_wins('5', '7')
    assert_equal 0, team_manager.total_wins('5', '8')
    assert_equal 1, team_manager.total_wins('5', '6')
    assert_equal 0, team_manager.total_wins('5', '2')
  end

  def test_it_can_calculate_average_win_percentage_for_a_team
    stat_tracker = mock('A totally legit stat_tracker')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    game1 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game2 = { '8' => { result: 'TIE' }, '5' => { result: 'TIE' } }
    game3 = { '5' => { result: 'WIN' }, '12' => { result: 'LOSS' } }
    game4 = { '5' => { result: 'WIN' }, '2' => { result: 'LOSS' } }
    game5 = { '5' => { result: 'WIN' }, '7' => { result: 'LOSS' } }
    game_teams_info = [game1, game2, game3, game4, game5]
    team_manager.stubs(:gather_game_team_info).returns(game_teams_info)

    assert_equal (3 / 5.0).round(2), team_manager.average_win_percentage('5')
  end

  def test_it_can_count_games_against_an_opponent
    stat_tracker = mock('A totally legit stat_tracker')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    game1 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game2 = { '8' => { result: 'TIE' }, '5' => { result: 'TIE' } }
    game3 = { '5' => { result: 'WIN' }, '12' => { result: 'LOSS' } }
    game4 = { '5' => { result: 'WIN' }, '2' => { result: 'LOSS' } }
    game5 = { '5' => { result: 'WIN' }, '7' => { result: 'LOSS' } }
    game6 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game7 = { '5' => { result: 'WIN' }, '6' => { result: 'LOSS' } }
    game8 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game_teams_info = [game1, game2, game3, game4, game5, game6, game7, game8]
    team_manager.stubs(:gather_game_team_info).returns(game_teams_info)

    assert_equal 4, team_manager.opponent_game_count('5', '6')
    assert_equal 1, team_manager.opponent_game_count('5', '8')
    assert_equal 1, team_manager.opponent_game_count('5', '7')
    assert_equal 1, team_manager.opponent_game_count('5', '12')
    assert_equal 1, team_manager.opponent_game_count('5', '2')
    assert_equal 0, team_manager.opponent_game_count('5', '24')
  end

  def test_it_can_calculate_average_win_percentage_for_an_opponent
    stat_tracker = mock('A totally legit stat_tracker')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    game1 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game2 = { '8' => { result: 'TIE' }, '5' => { result: 'TIE' } }
    game3 = { '5' => { result: 'WIN' }, '12' => { result: 'LOSS' } }
    game4 = { '5' => { result: 'WIN' }, '2' => { result: 'LOSS' } }
    game5 = { '5' => { result: 'WIN' }, '7' => { result: 'LOSS' } }
    game6 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game7 = { '5' => { result: 'WIN' }, '6' => { result: 'LOSS' } }
    game8 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game_teams_info = [game1, game2, game3, game4, game5, game6, game7, game8]
    team_manager.stubs(:gather_game_team_info).returns(game_teams_info)

    assert_equal (3 / 4.0).round(2), team_manager.opponent_win_percentage('5', '6')
  end

  def test_it_can_find_all_opponent_ids
    stat_tracker = mock('A totally legit stat_tracker')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    game1 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game2 = { '8' => { result: 'TIE' }, '5' => { result: 'TIE' } }
    game3 = { '5' => { result: 'WIN' }, '12' => { result: 'LOSS' } }
    game4 = { '5' => { result: 'WIN' }, '2' => { result: 'LOSS' } }
    game5 = { '5' => { result: 'WIN' }, '7' => { result: 'LOSS' } }
    game6 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game7 = { '5' => { result: 'WIN' }, '6' => { result: 'LOSS' } }
    game8 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game_teams_info = [game1, game2, game3, game4, game5, game6, game7, game8]
    team_manager.stubs(:gather_game_team_info).returns(game_teams_info)
    expected = ['2', '6', '7', '8', '12']

    assert_equal expected, team_manager.opponent_ids('5')
  end

  def test_it_can_find_a_teams_favorite_opponent
    stat_tracker = mock('A totally legit stat_tracker')
    team5 = mock('team 5')
    team5.stubs(:team_id).returns('5')
    team5.stubs(:team_info).returns({ 'team_name' => 'The Fives' })
    team2 = mock('team 2')
    team2.stubs(:team_id).returns('2')
    team2.stubs(:team_info).returns({ 'team_name' => 'The Twos' })
    team6 = mock('team 6')
    team6.stubs(:team_id).returns('6')
    team6.stubs(:team_info).returns({ 'team_name' => 'The Sixes' })
    team7 = mock('team 7')
    team7.stubs(:team_id).returns('7')
    team7.stubs(:team_info).returns({ 'team_name' => 'The Sevens' })
    team8 = mock('team 8')
    team8.stubs(:team_id).returns('8')
    team8.stubs(:team_info).returns({ 'team_name' => 'The Ochos' })
    team12 = mock('team 12')
    team12.stubs(:team_id).returns('12')
    team12.stubs(:team_info).returns({ 'team_name' => 'The Twelves' })
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    teams = [team2, team5, team6, team7, team8, team12]
    team_manager.stubs(:teams).returns(teams)
    game1 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game2 = { '8' => { result: 'TIE' }, '5' => { result: 'TIE' } }
    game3 = { '5' => { result: 'WIN' }, '12' => { result: 'LOSS' } }
    game4 = { '5' => { result: 'WIN' }, '2' => { result: 'LOSS' } }
    game5 = { '5' => { result: 'WIN' }, '7' => { result: 'LOSS' } }
    game6 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game7 = { '5' => { result: 'WIN' }, '6' => { result: 'LOSS' } }
    game8 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game_teams_info = [game1, game2, game3, game4, game5, game6, game7, game8]
    team_manager.stubs(:gather_game_team_info).returns(game_teams_info)

    assert_equal 'The Twos', team_manager.favorite_opponent('5')
  end

  def test_it_can_find_a_teams_rival
    stat_tracker = mock('A totally legit stat_tracker')
    team5 = mock('team 5')
    team5.stubs(:team_id).returns('5')
    team5.stubs(:team_info).returns({ 'team_name' => 'The Fives' })
    team2 = mock('team 2')
    team2.stubs(:team_id).returns('2')
    team2.stubs(:team_info).returns({ 'team_name' => 'The Twos' })
    team6 = mock('team 6')
    team6.stubs(:team_id).returns('6')
    team6.stubs(:team_info).returns({ 'team_name' => 'The Sixes' })
    team7 = mock('team 7')
    team7.stubs(:team_id).returns('7')
    team7.stubs(:team_info).returns({ 'team_name' => 'The Sevens' })
    team8 = mock('team 8')
    team8.stubs(:team_id).returns('8')
    team8.stubs(:team_info).returns({ 'team_name' => 'The Ochos' })
    team12 = mock('team 12')
    team12.stubs(:team_id).returns('12')
    team12.stubs(:team_info).returns({ 'team_name' => 'The Twelves' })
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    teams = [team2, team5, team6, team7, team8, team12]
    team_manager.stubs(:teams).returns(teams)
    game1 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game2 = { '8' => { result: 'TIE' }, '5' => { result: 'TIE' } }
    game3 = { '5' => { result: 'WIN' }, '12' => { result: 'LOSS' } }
    game4 = { '5' => { result: 'WIN' }, '2' => { result: 'LOSS' } }
    game5 = { '5' => { result: 'WIN' }, '7' => { result: 'LOSS' } }
    game6 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game7 = { '5' => { result: 'WIN' }, '6' => { result: 'LOSS' } }
    game8 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game_teams_info = [game1, game2, game3, game4, game5, game6, game7, game8]
    team_manager.stubs(:gather_game_team_info).returns(game_teams_info)

    assert_equal 'The Sixes', team_manager.rival('5')
  end

  def test_it_can_separate_game_ids_by_season_id
    stat_tracker = mock('A totally legit stat_tracker')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    game1 = { season_id: '20122013', game_id: 1 }
    game2 = { season_id: '20122013', game_id: 2 }
    game3 = { season_id: '20132014', game_id: 3 }
    game4 = { season_id: '20142015', game_id: 4 }
    game_info = [game1, game2, game3, game4]
    team_manager.stubs(:gather_game_info).returns(game_info)
    expected = {
      '20122013' => [1, 2],
      '20132014' => [3],
      '20142015' => [4]
    }

    assert_equal expected, team_manager.game_ids_by_season('a team_id')
  end

  def test_it_can_generate_game_teams_by_season
    stat_tracker = mock('A totally legit stat_tracker')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    seasons = {
      '20122013' => [1, 2],
      '20132014' => [3],
      '20142015' => [4]
    }
    team_manager.stubs(:game_ids_by_season).returns(seasons)
    team_manager.stubs(:game_team_info).returns('game_team info')
    expected = {
      '20122013' => ['game_team info', 'game_team info'],
      '20132014' => ['game_team info'],
      '20142015' => ['game_team info']
    }

    assert_equal expected, team_manager.game_teams_by_season('1')
  end

  def test_it_can_count_season_wins_by_team
    stat_tracker = mock('A totally legit stat_tracker')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    game1 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game2 = { '8' => { result: 'TIE' }, '5' => { result: 'TIE' } }
    game3 = { '5' => { result: 'WIN' }, '12' => { result: 'LOSS' } }
    game4 = { '5' => { result: 'WIN' }, '2' => { result: 'LOSS' } }
    game5 = { '5' => { result: 'WIN' }, '7' => { result: 'LOSS' } }
    game6 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game7 = { '5' => { result: 'WIN' }, '6' => { result: 'LOSS' } }
    game8 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    gt_by_season = {
      '20122013' => [game1, game2, game5, game6],
      '20132014' => [game3, game7],
      '20142015' => [game4, game8]
    }

    assert_equal 1, team_manager.count_season_wins('5', gt_by_season['20122013'])
    assert_equal 2, team_manager.count_season_wins('5', gt_by_season['20132014'])
    assert_equal 1, team_manager.count_season_wins('5', gt_by_season['20142015'])
  end

  def test_it_can_find_a_teams_best_season
    stat_tracker = mock('A totally legit stat_tracker')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    game1 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game2 = { '8' => { result: 'TIE' }, '5' => { result: 'TIE' } }
    game3 = { '5' => { result: 'WIN' }, '12' => { result: 'LOSS' } }
    game4 = { '5' => { result: 'WIN' }, '2' => { result: 'LOSS' } }
    game5 = { '5' => { result: 'WIN' }, '7' => { result: 'LOSS' } }
    game6 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game7 = { '5' => { result: 'WIN' }, '6' => { result: 'LOSS' } }
    game8 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    gt_by_season = {
      '20122013' => [game1, game2, game5, game6],
      '20132014' => [game3, game7],
      '20142015' => [game4, game8]
    }
    team_manager.stubs(:game_teams_by_season).returns(gt_by_season)

    assert_equal '20132014', team_manager.best_season('5')
  end

  def test_it_can_find_a_teams_worst_season
    stat_tracker = mock('A totally legit stat_tracker')
    CSV.stubs(:foreach).returns(nil)
    team_manager = TeamManager.new('A totally legit path', stat_tracker)
    game1 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game2 = { '8' => { result: 'TIE' }, '5' => { result: 'TIE' } }
    game3 = { '5' => { result: 'WIN' }, '12' => { result: 'LOSS' } }
    game4 = { '5' => { result: 'LOSS' }, '2' => { result: 'WIN' } }
    game5 = { '5' => { result: 'WIN' }, '7' => { result: 'LOSS' } }
    game6 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    game7 = { '5' => { result: 'WIN' }, '6' => { result: 'LOSS' } }
    game8 = { '5' => { result: 'LOSS' }, '6' => { result: 'WIN' } }
    gt_by_season = {
      '20122013' => [game1, game2, game5, game6],
      '20132014' => [game3, game7],
      '20142015' => [game4, game8]
    }
    team_manager.stubs(:game_teams_by_season).returns(gt_by_season)

    assert_equal '20142015', team_manager.worst_season('5')
  end

  def test_it_can_find_team_data_by_id
    assert_equal 32, @team_manager.team_data_by_id.count
  end
end
