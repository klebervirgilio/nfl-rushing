defmodule Mix.Tasks.ImportNflPlayerStats do
  use Mix.Task
  require Logger

  @moduledoc """
    Usage:

    ```
    mix import_nfl_player_stats --json /absolute/path/to/file.json
    ```
  """
  @shortdoc "Import NFL Player stats from file"

  @requirements ["app.start"]
  def run(["--json", path]) do
    with {:read_file, {:ok, raw_json}} <- {:read_file, File.read(path)},
         {:decode, {:ok, json}} <- {:decode, Jason.decode(raw_json)} do
      NFLRusingLoader.Adapter.load(json)
    else
      {:read_file, error} ->
        Logger.error("Could not read file, error: #{inspect(error)}")

      {:decode, error} ->
        Logger.error("Invalid JSON, error: #{inspect(error)}")
    end
  end
end
