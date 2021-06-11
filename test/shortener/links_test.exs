defmodule Shortener.LinksTest do
  use Shortener.DataCase

  import Shortener.Factory

  alias Shortener.Links
  alias Shortener.Links.Link

  describe "links" do
    @valid_attrs %{"url" => "http://exmaple.com"}
    @invalid_attrs %{"url" => ""}

    test "list_links/2 returns links" do
      link = insert(:link)
      another_link = insert(:link)
      assert Links.list_links(1, 2) == [link, another_link]
    end

    test "list_links/2 paginates links" do
      link = insert(:link)
      insert(:link)
      assert Links.list_links(1, 1) == [link]
    end

    test "get_or_create_link_by/1 with valid data creates a link" do
      assert {:ok, %Link{} = link} = Links.get_or_create_link_by(@valid_attrs)
      assert link.url == @valid_attrs["url"]
    end

    test "get_or_create_link_by/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Links.get_or_create_link_by(@invalid_attrs)
    end

    test "change_link/1 returns a link changeset" do
      link = build(:link)
      assert %Ecto.Changeset{} = Links.change_link(link)
    end
  end
end
