defmodule ShortenerWeb.LinkLive.Index do
  use ShortenerWeb, :live_view

  alias Shortener.Services
  alias Shortener.Services.Link

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(%{page: 1, per_page: 30}) |> fetch()}
  end

  @impl true
  def handle_event("load-more", _, %{assigns: assigns} = socket) do
    {:noreply, socket |> assign(page: assigns.page + 1) |> fetch()}
  end

  defp fetch(%{assigns: %{page: page, per_page: per_page}} = socket) do
    assign(socket, %{links: Services.list_links(page, per_page)})
  end

  defp absolute_url(%Link{hash: hash}) do
    "#{ShortenerWeb.Endpoint.url()}/r/#{hash}"
  end
end
