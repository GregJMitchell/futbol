require_relative 'game_manager'
require_relative 'game_team_manager'
require_relative 'team_manager'


class StatTracker
  attr_reader :game_team_manager, :game_manager, :team_manager
  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def initialize(locations)
    load_managers(locations)
  end

  def load_managers(locations)
    @team_manager = TeamManager.new(locations, self)
    @game_team_manager = GameTeamManager.new(locations, self)
    @game_manager = GameManager.new(locations, self)
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

  def team_info(team_id)
    @team_manager.team_info(team_id)
  end

  #League Stats

  def count_of_teams
    @team_manager.count_of_teams
  end

  def best_offense
    @game_manager.best_offense
  end

  def worst_offense
    @game_manager.worst_offense
  end

  def highest_scoring_visitor
    @game_manager.highest_scoring_visitor
  end

  def highest_scoring_home_team
    @game_manager.highest_scoring_home_team
  end

  def lowest_scoring_visitor
    @game_manager.lowest_scoring_visitor
  end

  def lowest_scoring_home_team
    @game_manager.lowest_scoring_home_team
  end

  # Season Statistics
  def winningest_coach(season_id)
    @game_team_manager.winningest_coach(season_id)
  end

  def worst_coach(season_id)
    @game_team_manager.worst_coach(season_id)
  end

  def most_accurate_team(season_id)
    @game_team_manager.most_accurate_team(season_id)
  end

  def least_accurate_team(season_id)
    @game_team_manager.least_accurate_team(season_id)
  end

  def most_tackles(season_id)
    @game_team_manager.most_tackles(season_id)
  end

  def fewest_tackles(season_id)
    @game_team_manager.fewest_tackles(season_id)
  end
end
