require_relative 'game_manager'
require_relative 'game_team_manager'
require_relative 'team_manager'

class StatTracker
  attr_reader :game_team_manager, :game_manager, :team_manager
  def self.from_csv(locations) # I need a test
    StatTracker.new(locations)
  end

  def initialize(locations) # I maybe need a test?
    load_managers(locations)
  end

  def load_managers(locations)
    @team_manager = TeamManager.new(locations[:teams], self)
    @game_team_manager = GameTeamManager.new(locations[:game_teams], self)
    @game_manager = GameManager.new(locations[:games], self)
  end

  #Game Stats
  def highest_total_score
    @game_manager.highest_total_score
  end

  def lowest_total_score
    @game_manager.lowest_total_score
  end

  def percentage_home_wins
    @game_manager.percentage_home_wins
  end

  def percentage_visitor_wins
    @game_manager.percentage_visitor_wins
  end

  def percentage_ties
    @game_manager.percentage_ties
  end

  def count_of_games_by_season
    @game_manager.count_of_games_by_season
  end

  def average_goals_per_game
    @game_manager.average_goals_per_game
  end

  def average_goals_by_season
    @game_manager.average_goals_by_season
  end

  # Team Stats

  def team_info(team_id)
    team_manager.find_team(team_id).team_info
  end

  def game_ids_by_team(team_id)
    game_team_manager.game_ids_by_team(team_id)
  end

  def game_team_info(game_id)
    game_team_manager.game_team_info(game_id)
  end

  def game_info(game_id)
    game_manager.game_info(game_id)
  end

  def average_win_percentage(team_id)
    team_manager.average_win_percentage(team_id)
  end

  def favorite_opponent(team_id)
    team_manager.favorite_opponent(team_id)
  end

  def rival(team_id)
    team_manager.rival(team_id)
  end

  def most_goals_scored(team_id)
    team_manager.most_goals_scored(team_id)
  end

  def fewest_goals_scored(team_id)
    team_manager.fewest_goals_scored(team_id)
  end

  def best_season(team_id)
    team_manager.best_season(team_id)
  end

  def worst_season(team_id)
    team_manager.worst_season(team_id)
  end

  #League Stats

  def count_of_teams
    @team_manager.count_of_teams
  end

  def best_offense
    @game_team_manager.best_offense
  end

  def worst_offense
    @game_team_manager.worst_offense
  end

  def highest_scoring_visitor
    @game_team_manager.highest_scoring_visitor
  end

  def highest_scoring_home_team
    @game_team_manager.highest_scoring_home_team
  end

  def lowest_scoring_visitor
    @game_team_manager.lowest_scoring_visitor
  end

  def lowest_scoring_home_team
    @game_team_manager.lowest_scoring_home_team
  end

  # Season Statistics
  def winningest_coach(season_id)
    @game_team_manager.winningest_coach(season_id)
  end

  def worst_coach(season_id)
    @game_team_manager.worst_coach(season_id)
  end

  def most_accurate_team(season_id)
    team_info(@game_team_manager.most_accurate_team(season_id))['team_name']
  end

  def least_accurate_team(season_id)
    team_info(@game_team_manager.least_accurate_team(season_id))['team_name']
  end

  def most_tackles(season_id)
    team_info(@game_team_manager.most_tackles(season_id))['team_name']
  end

  def fewest_tackles(season_id)
    team_info(@game_team_manager.fewest_tackles(season_id))['team_name']
  end

  def team_data
    team_manager.team_data_by_id
  end
end
