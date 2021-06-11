defmodule ShortenerWeb.RedirectController do
  use ShortenerWeb, :controller

  alias Shortener.Links

  def show(conn, %{"hash" => hash}) do
    url =
      hash
      |> Links.get_link_by_hash!()
      |> Map.get(:url)

    redirect(conn, external: url)
  end
end
