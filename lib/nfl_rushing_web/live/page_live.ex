defmodule NflRushingWeb.PageLive do
  use NflRushingWeb, :live_view

  alias NflRushing.NFLStats

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, sort_by: %{}, per_page: 10, players: NFLStats.paginated_players())}
  end

  @impl true
  def handle_event("update_players", %{"pagination" => %{"per_page" => per_page}}, socket) do
    {:noreply, assign(socket, players: NFLStats.paginated_players(page_size: per_page))}
  end

  @impl true
  def handle_event("search", %{"value" => value}, socket) do
    {:noreply,
     update(
       socket,
       :players,
       &NFLStats.search_players_by_name(value, page_size: &1.page_size, page: &1.page_number - 1)
     )}
  end

  @impl true
  def handle_event("prev_page", _params, socket) do
    {:noreply,
     update(
       socket,
       :players,
       &NFLStats.paginated_players(page_size: &1.page_size, page: &1.page_number - 1)
     )}
  end

  @impl true
  def handle_event("next_page", _params, socket) do
    {:noreply,
     update(
       socket,
       :players,
       &NFLStats.paginated_players(page_size: &1.page_size, page: &1.page_number + 1)
     )}
  end

  @impl true
  def handle_event("sort_by", %{"sort_by" => "nothing"}, socket) do
    players = socket.assigns.players

    {:noreply,
     assign(socket,
       sort_by: %{},
       players:
         NFLStats.paginated_players(
           page_size: players.page_size,
           page: players.page_number
         )
     )}
  end

  def handle_event("sort_by", %{"sort_by" => column}, socket) do
    column = String.to_atom(column)

    sort_by =
      Map.update(socket.assigns.sort_by, column, :asc, fn
        :desc -> :asc
        :asc -> :desc
      end)

    players = socket.assigns.players

    ksort_by = Enum.zip(Map.values(sort_by), Map.keys(sort_by)) |> Enum.into([])

    {:noreply,
     assign(socket,
       sort_by: sort_by,
       players:
         NFLStats.sort_by(ksort_by, page_size: players.page_size, page: players.page_number)
     )}
  end

  def options_for_select_with_selected(options, selected) do
    Enum.map(options, fn option ->
      [key: option, value: option, selected: option == selected]
    end)
  end

  def sort_by_class(sort_by, active_filter) do
    if Map.has_key?(sort_by, active_filter) do
      "table-secondary"
    else
      "table-light"
    end
  end

  def sort_by_icon(sort_by, active_filter) do
    case Map.get(sort_by, active_filter) do
      :asc -> "bi-sort-alpha-down"
      :desc -> "bi-sort-alpha-up"
      _ -> ""
    end
  end
end
