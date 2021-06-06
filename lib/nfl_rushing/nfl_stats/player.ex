defmodule NflRushing.NFLStats.Player do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "player_stats" do
    field :longest_rush, :integer
    field :name, :string
    field :postion, :string
    field :rushing_20_yards_each, :integer
    field :rushing_40_yards_each, :integer
    field :rushing_attempts, :integer
    field :rushing_attempts_per_game, :float
    field :rushing_average_yards_per_attempt, :float
    field :rushing_first_downs, :integer
    field :rushing_first_downs_percentage, :float
    field :rushing_fumbles, :integer
    field :rushing_yards_per_game, :float
    field :team, :string
    field :total_rushing_touchdowns, :integer
    field :total_rushing_yards, :float

    timestamps()
  end

  @fields [
    :name,
    :team,
    :postion,
    :rushing_attempts_per_game,
    :rushing_attempts,
    :total_rushing_yards,
    :rushing_average_yards_per_attempt,
    :rushing_yards_per_game,
    :total_rushing_touchdowns,
    :longest_rush,
    :rushing_first_downs,
    :rushing_first_downs_percentage,
    :rushing_20_yards_each,
    :rushing_40_yards_each,
    :rushing_fumbles
  ]

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> unique_constraint([:name, :team])
  end
end
