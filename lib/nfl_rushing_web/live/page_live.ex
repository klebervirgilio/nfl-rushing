defmodule NflRushingWeb.PageLive do
  use NflRushingWeb, :live_view

  alias NflRushing.NFLStats

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", per_page: 10, players: NFLStats.paginated_players())}
  end

  @impl true
  def handle_event("update_players", %{"pagination" => %{"per_page" => per_page}}, socket) do
    {:noreply, assign(socket, players: NFLStats.paginated_players(page_size: per_page))}
  end

  def options_for_select_with_selected(options, selected) do
    Enum.map(options, fn option ->
      [key: option, value: option, selected: option == selected]
    end)
  end
end
