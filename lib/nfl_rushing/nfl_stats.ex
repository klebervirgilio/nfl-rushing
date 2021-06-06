defmodule NflRushing.NFLStats do
  alias NflRushing.NFLStats.Player
  alias NflRushing.Repo

  def create_player(player_attrs = %{}) do
    %Player{}
    |> Player.changeset(player_attrs)
    |> Repo.insert(
      on_conflict: {:replace_all_except, ~w[id inserted_at name team]a},
      conflict_target: ~w[name team]a
    )
  end
end
