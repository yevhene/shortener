# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Shortener.Repo.insert!(%Shortener.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Shortener.Links.Link
alias Shortener.Repo

0..100
|> Enum.map(fn i ->
  {:ok, link} =
    %Link{url: "http://example.com/url-#{i}", hash: "#{i}"}
    |> Repo.insert()

  link
end)
