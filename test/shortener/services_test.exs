defmodule Shortener.ServicesTest do
  use Shortener.DataCase

  alias Shortener.Services

  describe "links" do
    alias Shortener.Services.Link

    @valid_attrs %{hash: "some hash", url: "some url"}
    @another_valid_attrs %{hash: "another hash", url: "another url"}

    def link_fixture(attrs \\ %{}) do
      {:ok, link} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Services.create_link()

      link
    end

    test "list_links/2 returns links" do
      link = link_fixture()
      another_link = link_fixture(@another_valid_attrs)
      assert Services.list_links(1, 2) == [link, another_link]
    end

    test "list_links/2 paginates links" do
      link = link_fixture()
      another_link = link_fixture(@another_valid_attrs)
      assert Services.list_links(1, 1) == [link]
    end
  end
end
