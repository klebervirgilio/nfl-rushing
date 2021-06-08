defmodule NflRushing.NFLStats do
  alias NflRushing.NFLStats.Player
  alias NflRushing.Repo

  import Ecto.Query

  def players() do
    from(p in Player, order_by: :name)
  end

  @spec search_players_by_name(Ecto.Query.t(), String.t()) :: Ecto.Query.t()
  def search_players_by_name(_, value) when not is_binary(value) or length(value) == 0,
    do: players()

  def search_players_by_name(querable, query) do
    querable
    |> where([t], fragment("similarity(?, ?) > ?", t.name, ^query, 0.2))
  end

  @spec sort_by(Ecto.Query.t(), keyword()) :: Ecto.Query.t()
  def sort_by(querable, values) do
    querable
    |> order_by([t], ^values)
  end

  @spec paginated_players(Ecto.Query.t(), keyword()) :: Ecto.Query.t()
  def paginated_players(querable, paginaiton_opts \\ []) do
    Repo.paginate(querable, paginaiton_opts)
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
