module DataCall
  def team_data
    @stat_tracker.team_manager.teams
  end

  def game_ids_by_team(id)
    game_teams.select { |game_team| game_team.team_id == id }.map(&:game_id)
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

  def group_by_season
    @games.group_by { |game| game.season }.uniq
  end

  def game_info(game_id)
    games.find {|game| game.game_id == game_id }.game_info
  end

  def game_ids_by_season(id)
    gather_game_info(id).reduce({}) do |collector, game|
      collector[game[:season_id]] = [] if collector[game[:season_id]].nil?
      collector[game[:season_id]] << game[:game_id]
      collector
    end
  end

  def game_teams_by_season(id)
    seasons = game_ids_by_season(id)
    seasons.each do |season, game_ids|
      seasons[season] = game_ids.map do |game_id|
        game_team_info(game_id)
      end
    end
    seasons

  end
end