class Game
  attr_reader :game_id, :season, :type, :date_time, :away_team_id, :home_team_id, :away_goals,
              :home_goals, :venue, :venue_link
  def initialize(row)
    row.each do |k, v|
        instance_variable_set("@#{k}", v)
    end
    @away_goals = @away_goals.to_i
    @home_goals = @home_goals.to_i
  end

  def game_info
    {
      season_id: season,
      game_id: game_id,
      home_team_id: home_team_id,
      away_team_id: away_team_id,
      home_goals: home_goals,
      away_goals: away_goals
    }
  end
end
