defmodule NflRushing.NFLStats do
  alias NflRushing.NFLStats.Player
  alias NflRushing.Repo

  import Ecto.Query, only: [from: 2]

  def paginated_players(paging_opts \\ []) do
    from(p in Player, order_by: [asc: :name])
    |> Repo.paginate(paging_opts)
  end

  def create_player(player_attrs = %{}) do
    %Player{}
    |> Player.changeset(player_attrs)
    |> Repo.insert(
      on_conflict: {:replace_all_except, ~w[id inserted_at name team]a},
      conflict_target: ~w[name team]a
    )
  end
end
