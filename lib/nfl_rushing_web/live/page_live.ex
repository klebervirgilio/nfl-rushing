defmodule NflRushingWeb.PageLive do
  use NflRushingWeb, :live_view

  alias NflRushing.NFLStats

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", players: NFLStats.paginated_players)}
  end
end
