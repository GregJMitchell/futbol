require_relative 'game'
require_relative 'csv_module'
require 'csv'

class GameManager
  include CSVModule
  attr_reader :games
  def initialize(locations, stat_tracker)
    @stat_tracker = stat_tracker
    @games = generate_games(locations[:games])
  end

  def group_by_season
    @games.group_by do |game|
      game.season
    end.uniq
  end

  def best_offense
    avg = return_average_goals_per_game(data_away + data_home)
    team_data[return_max(avg)]["team_name"]
  end

  def worst_offense
    avg = return_average_goals_per_game(data_away + data_home)
    team_data[return_min(avg)]["team_name"]
  end

  def highest_scoring_visitor
    avg = return_average_goals_per_game(data_away)
    team_data[return_max(avg)]["team_name"]
  end

  def highest_scoring_home_team
    avg = return_average_goals_per_game(data_home)
    team_data[return_max(avg)]["team_name"]
  end

  def lowest_scoring_visitor
    avg = return_average_goals_per_game(data_away)
    team_data[return_min(avg)]["team_name"]
  end

  def lowest_scoring_home_team
    avg = return_average_goals_per_game(data_home)
    team_data[return_min(avg)]["team_name"]
  end

  def return_average_goals_per_game(scoredata)
    avghash = {}
    team_data.keys.each do |team|
      goals = 0
      scoredata.each do |score|
        if score[0] == team
          goals += score[1]
        end
      end
      avghash[team] = (goals.to_f / (scoredata.flatten.count(team))).round(4)
    end
    avghash
  end

  def data_home
    @games.map {|game| [game.home_team_id, game.home_goals]}
  end

  def data_away
    @games.map {|game| [game.away_team_id, game.away_goals]}
  end

  def team_data
    @stat_tracker.team_manager.teams_data
  end

  def return_max(hash)
    hash.key(hash.values.max)
  end

  def return_min(hash)
    hash.key(hash.values.min)
  end

  def average_goals_by_season
    seasons_hash = {}
    group_by_season.each do |season|
      total = 0
      season[1].each do |game|
        total += game.away_goals + game.home_goals
      end
      seasons_hash[season[0]] = (total/season[1].length.to_f).round(2)
    end
    seasons_hash
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
    seasons = []
    seasons_hash = {}
    @games.each do |game|
      seasons << game.season unless seasons.include? game.season
    end
    seasons.each do |season|
      seasons_hash[season] = @games.count { |game| game.season == season }
    end
    seasons_hash
  end

  def average_goals_per_game
    total = 0
    @games.each do |game|
      average_goals = (game.away_goals + game.home_goals) / @games.length.to_f
      total += average_goals
    end
    total.round(2)
  end
end
