module DataCall
  def team_data
    @stat_tracker.team_manager.teams
  end

  def games_by_team(team_id)
    games.select do |game|
      game.home_team_id == team_id || game.away_team_id == team_id
    end
  end

  def find_game_teams(game_id)
    game_teams.select do |game_team|
      game_team.game_id == game_id
    end
  end

  def game_team_info(game_id)
    find_game_teams(game_id).reduce({}) do |collector, game|
      collector[game.team_id] = game.game_team_info
      collector
    end
  end

  def gather_game_team_info(game_ids)
    game_ids.map do |game_id|
      game_team_info(game_id)
    end
  end

  def group_by_season
    @games.group_by { |game| game.season }.uniq
  end

  def game_info(game_id)
    games.find {|game| game.game_id == game_id }.game_info
  end

  def game_ids_by_season(team_id)
    gather_game_info(team_id).reduce({}) do |collector, game|
      collector[game[:season_id]] = [] if collector[game[:season_id]].nil?
      collector[game[:season_id]] << game[:game_id]
      collector
    end
  end

  def game_teams_by_season(team_id)
    seasons = game_ids_by_season(team_id)
    seasons.each do |season, game_ids|
      seasons[season] = game_ids.map do |game_id|
        game_team_info(game_id)
      end
    end
    seasons

  end
end
