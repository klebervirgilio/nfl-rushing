defmodule NFLRusingLoader.Adapter do
  import NFLRusingLoader.Helpers

  alias NflRushing.NFLStats

  require Logger

  def load(players) do
    players
    |> create_players()
    |> Enum.reduce(%{errors: 0, ok: 0}, fn
      {:error, _}, acc ->
        Map.update!(acc, :errors, &(&1 + 1))

      {:ok, _}, acc ->
        Map.update!(acc, :ok, &(&1 + 1))
    end)
    |> (fn result ->
          Logger.info("Records created/updated: #{result[:ok]}")
          Logger.error("Errors: #{result[:errors]}")
        end).()
  end

  defp create_players(players) when is_list(players) do
    {:ok, result} =
      NflRushing.Repo.transaction(fn ->
        Enum.map(players, &create_player/1)
      end)

    result
  end

  defp create_player(player_attrs = %{}),
    do: player_attrs |> map_attrs() |> NFLStats.create_player()

  defp map_attrs(player_attrs),
    do:
      {player_attrs, %{}}
      |> map_attr("Player", :name, &String.trim/1)
      |> map_attr("Team", :team, &String.trim/1)
      |> map_attr("Pos", :postion, &String.trim/1)
      |> map_attr("Att", :rushing_attempts, &handle_integer/1)
      |> map_attr("Att/G", :rushing_attempts_per_game, &handle_float/1)
      |> map_attr("Yds", :total_rushing_yards, &handle_float/1)
      |> map_attr("Avg", :rushing_average_yards_per_attempt, &handle_float/1)
      |> map_attr("Yds/G", :rushing_yards_per_game, &handle_float/1)
      |> map_attr("TD", :total_rushing_touchdowns, &handle_integer/1)
      |> map_attr("Lng", :longest_rush, &handle_integer/1)
      |> map_attr("1st", :rushing_first_downs, &handle_integer/1)
      |> map_attr("1st%", :rushing_first_downs_percentage, &handle_float/1)
      |> map_attr("20+", :rushing_20_yards_each, &handle_integer/1)
      |> map_attr("40+", :rushing_40_yards_each, &handle_integer/1)
      |> map_attr("FUM", :rushing_fumbles, &handle_integer/1)
      |> elem(1)

  defp map_attr({from_map, to_map}, from_key, to_key, func) do
    value = Map.get(from_map, from_key)
    {from_map, Map.put(to_map, to_key, func.(value))}
  end
end
