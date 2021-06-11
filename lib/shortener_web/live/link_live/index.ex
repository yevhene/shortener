defmodule ShortenerWeb.LinkLive.Index do
  use ShortenerWeb, :live_view

  import ShortenerWeb.LinkHelpers

  alias Shortener.Links

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> reset_pagination() |> fetch() |> subscribe()}
  end

  @impl true
  def handle_info({{:links, :updated}, link}, socket) do
    {:noreply, socket |> assign(links: [link], phx_update: "prepend")}
  end

  @impl true
  def handle_event("load-more", _, %{assigns: assigns} = socket) do
    {:noreply,
     socket |> assign(page: assigns.page + 1, phx_update: "append") |> fetch()}
  end

  defp fetch(%{assigns: %{page: page, per_page: per_page}} = socket) do
    assign(socket, %{links: Links.list_links(page, per_page)})
  end

  defp reset_pagination(socket) do
    socket |> assign(%{page: 1, per_page: 30, phx_update: "replace"})
  end

  defp subscribe(conn) do
    Links.subscribe()
    conn
  end
end
