defmodule NflRushing.Repo.Migrations.AddIndexToPlayersName do
  use Ecto.Migration

  def up do
    execute "CREATE extension if not exists pg_trgm;"
    execute "CREATE INDEX player_stats_name_trgm_index ON player_stats USING gin (name gin_trgm_ops);"
  end

  def down do
    execute "DROP INDEX IF EXISTS player_stats_name_trgm_index;"
  end
end
