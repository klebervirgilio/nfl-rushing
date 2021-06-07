defmodule NflRushing.NFLStats do
  alias NflRushing.NFLStats.Player
  alias NflRushing.Repo

  import Ecto.Query

  def search_players_by_name("", paginaiton_opts), do: paginated_players(paginaiton_opts)

  def search_players_by_name(query, paginaiton_opts) do
    Player
    |> where([t], fragment("similarity(?, ?) > ?", t.name, ^query, 0.15))
    |> order_by([t], fragment("similarity(?, ?) DESC", t.name, ^query))
    |> Repo.paginate(paginaiton_opts)
  end

  def sort_by(values, paginaiton_opts) do
    Player
    |> order_by([t], ^values)
    |> Repo.paginate(paginaiton_opts)
  end

  def paginated_players(paginaiton_opts \\ []) do
    from(p in Player, order_by: [asc: :name])
    |> Repo.paginate(paginaiton_opts)
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
