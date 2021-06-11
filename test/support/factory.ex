defmodule Shortener.Factory do
  use ExMachina.Ecto, repo: Shortener.Repo

  alias Shortener.Links.Link

  def link_factory do
    %Link{
      url: sequence(:url, &"http://example.com/#{&1}"),
      hash: sequence(:hash, &"hash#{&1}")
    }
  end
end
