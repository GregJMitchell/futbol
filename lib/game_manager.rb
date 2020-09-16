require_relative 'game'
require_relative 'csv_module'
require_relative 'data_call'

class GameManager
  include CSVModule, DataCall
  attr_reader :games
  def initialize(location, stat_tracker)
    @stat_tracker = stat_tracker
    @games = generate_data(location, Game)
  end

  def average_goals(games)
    total = games.sum { |game| game.away_goals + game.home_goals }
    (total.to_f / games.length).round(2)
  end

  def average_goals_by_season
    group_by_season.reduce({}) do |season_avg, (season, games)|
      season_avg[season] = average_goals(games)
      season_avg
    end
  end

  def highest_total_score
    highest_score = highest_total_score_helper
    highest_score.away_goals + highest_score.home_goals
  end

  def highest_total_score_helper
    @games.max_by do |game|
      game.away_goals + game.home_goals
    end
  end

  def lowest_total_score
    min_score = lowest_total_score_helper
    min_score.away_goals + min_score.home_goals
  end

  def lowest_total_score_helper
    @games.min_by do |game|
      game.away_goals + game.home_goals
    end
  end

  def percentage_home_wins
    percent_wins = percentage_home_win_helper
    (percent_wins / @games.length.to_f).round(2)
  end

  def percentage_home_win_helper
    @games.count do |game|
      game.home_goals > game.away_goals
    end
  end

  def percentage_visitor_wins
    percent_wins = percentage_visitor_win_helper
    (percent_wins / @games.length.to_f).round(2)
  end

  def percentage_visitor_win_helper
    @games.count do |game|
      game.home_goals < game.away_goals
    end
  end

  def percentage_ties
    percent_ties = percentage_ties_helper
    (percent_ties / @games.length.to_f).round(2)
  end

  def percentage_ties_helper
    @games.count do |game|
      game.home_goals == game.away_goals
    end
  end

  def count_of_games_by_season
    group_by_season.reduce({}) do |games_season_count, (season, games)|
      games_season_count[season] = games.length
      games_season_count
    end
  end

  def average_goals_per_game
    average_goals(@games)
  end
end
