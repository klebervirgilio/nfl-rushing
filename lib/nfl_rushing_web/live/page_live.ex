defmodule NflRushingWeb.PageLive do
  use NflRushingWeb, :live_view

  alias NflRushing.NFLStats.Player
  alias NflRushing.NFLStats

  @impl true
  def mount(_params, _session, socket) do
    players = NFLStats.players()

    {:ok,
     assign(socket,
       querable: players,
       search_by: nil,
       sort_by: %{},
       per_page: 10,
       players: NFLStats.paginated_players(players)
     )}
  end

  @impl true
  def handle_event("update_players", %{"pagination" => %{"per_page" => per_page}}, socket) do
    {:noreply,
     assign(socket,
       players: NFLStats.paginated_players(socket.assigns.querable, page_size: per_page)
     )}
  end

  @impl true
  def handle_event("prev_page", _params, socket) do
    {:noreply,
     update(
       socket,
       :players,
       &NFLStats.paginated_players(socket.assigns.querable,
         page_size: &1.page_size,
         page: &1.page_number - 1
       )
     )}
  end

  @impl true
  def handle_event("next_page", _params, socket) do
    {:noreply,
     update(
       socket,
       :players,
       &NFLStats.paginated_players(socket.assigns.querable,
         page_size: &1.page_size,
         page: &1.page_number + 1
       )
     )}
  end

  @impl true
  def handle_event("search", %{"value" => value}, socket) do
    players = socket.assigns.players

    querable =
      if String.trim(value) == "" do
        socket.assigns.querable
      else
        build_query(socket.assigns.sort_by, value)
      end

    {:noreply,
     assign(
       socket,
       querable: querable,
       search_by: value,
       players:
         NFLStats.paginated_players(querable,
           page_size: players.page_size,
           page: players.page_number
         )
     )}
  end

  @impl true
  def handle_event("sort_by", %{"sort_by" => "nothing"}, socket) do
    players = socket.assigns.players
    querable = build_query(%{}, socket.assigns.search_by)

    {:noreply,
     assign(socket,
       sort_by: %{},
       querable: querable,
       players:
         NFLStats.paginated_players(
           querable,
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

    querable =
      if Enum.any?(sort_by) do
        build_query(sort_by, socket.assigns.search_by)
      else
        socket.assigns.querable
      end

    players = socket.assigns.players

    {:noreply,
     assign(socket,
       sort_by: sort_by,
       querable: querable,
       players:
         NFLStats.paginated_players(querable,
           page_size: players.page_size,
           page: players.page_number - 1
         )
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

  defp build_query(sort_by, search_by) do
    sort_by_keywords = Enum.zip(Map.values(sort_by), Map.keys(sort_by)) |> Enum.into([])

    Player
    |> NFLStats.sort_by(sort_by_keywords)
    |> NFLStats.search_players_by_name(search_by)
  end
end
