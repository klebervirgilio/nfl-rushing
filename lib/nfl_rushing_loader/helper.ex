defmodule NFLRusingLoader.Helpers do
  require Logger

  def handle_float(value) when is_nil(value), do: 0
  def handle_float(value) when is_number(value), do: value

  def handle_float(value) when is_binary(value) do
    try do
      value
      |> remove_chars()
      |> (fn v ->
            try do
              String.to_float(v)
            rescue
              _ -> String.to_integer(v)
            end
          end).()
      |> handle_float()
    rescue
      e ->
        Logger.warn("Cannot handle #{inspect(value)} error: #{inspect(e)}")
        0
    end
  end

  def handle_integer(value) when is_nil(value), do: 0
  def handle_integer(value) when is_number(value), do: value

  def handle_integer(value) when is_binary(value) do
    try do
      value
      |> remove_chars()
      |> String.to_integer()
      |> handle_integer()
    rescue
      e ->
        Logger.warn("Cannot handle #{inspect(value)} error: #{inspect(e)}")
        0
    end
  end

  defp remove_chars(value), do: String.replace(value, ~r/[^.,0-9]+/, "")
end
