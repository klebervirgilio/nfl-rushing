defmodule NflRushing.Repo.Migrations.CreatePlayerStats do
  use Ecto.Migration

  def change do
    create table(:player_stats, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :team, :string, null: false
      add :postion, :string, null: false
      add :rushing_attempts_per_game, :float, default: 0
      add :rushing_attempts, :integer, default: 0
      add :total_rushing_yards, :float, default: 0
      add :rushing_average_yards_per_attempt, :float, default: 0
      add :rushing_yards_per_game, :float, default: 0
      add :total_rushing_touchdowns, :integer, default: 0
      add :longest_rush, :integer, default: 0
      add :rushing_first_downs, :integer, default: 0
      add :rushing_first_downs_percentage, :float, default: 0
      add :rushing_20_yards_each, :integer, default: 0
      add :rushing_40_yards_each, :integer, default: 0
      add :rushing_fumbles, :integer, default: 0

      timestamps()
    end

    create index(:player_stats, ["total_rushing_yards DESC NULLS LAST"], name: :player_stats_total_rushing_yards_index)
    create index(:player_stats, ["longest_rush DESC NULLS LAST"], name: :player_stats_longest_rush_index)
    create index(:player_stats, ["total_rushing_touchdowns DESC NULLS LAST"], name: :player_stats_total_rushing_touchdowns_index)
    create unique_index(:player_stats,[:name, :team], name: :player_stats_player_unique_index)
  end
end
