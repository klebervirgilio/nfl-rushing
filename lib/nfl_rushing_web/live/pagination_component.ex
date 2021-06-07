defmodule PaginationComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
      <nav aria-label="Page navigation example">
      <ul class="pagination col justify-content-end">
        <li class="page-item <%= prev?(@players) %>">
          <a class="page-link" phx-click="prev_page" href="#">Previous</a>
        </li>
        <li class="page-item <%= next?(@players) %>">
          <a class="page-link" phx-click="next_page" href="#">Next</a>
        </li>
      </ul>
    </nav>
    """
  end

  defp prev?(%Scrivener.Page{page_number: 1}), do: "disabled"
  defp prev?(%Scrivener.Page{}), do: ""

  defp next?(%Scrivener.Page{page_number: page_number, total_pages: total_pages})
       when page_number == total_pages,
       do: "disabled"

  defp next?(%Scrivener.Page{}), do: ""
end
