defmodule ShortenerWeb.LinkHelpers do
  alias Shortener.Links.Link

  def absolute_url(%Link{hash: hash}) do
    "#{ShortenerWeb.Endpoint.url()}/#{hash}"
  end
end
