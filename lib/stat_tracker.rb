require_relative 'game_manager'
require_relative 'game_team_manager'
require_relative 'team_manager'


class StatTracker
  attr_reader :game_teams_manager, :game_manager, :team_manager
  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def initialize(locations)
    load_managers(locations)
  end

  def load_managers(locations)
    @game_manager = GameManager.new(locations, self)
    @team_manager = TeamManager.new(locations, self)
    @game_teams_manager = GameTeamManager.new(locations, self)
  end

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
end
