defmodule ShortenerWeb.LinkLiveTest do
  use ShortenerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Shortener.Factory

  defp create_link(_) do
    link = insert(:link)
    %{link: link}
  end

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Shortener"
    assert render(page_live) =~ "Shortener"
  end

  describe "Index" do
    setup [:create_link]

    test "lists links", %{conn: conn, link: link} do
      {:ok, _index_live, html} =
        live(conn, Routes.link_index_path(conn, :index))

      assert html =~ "Recent links"
      assert html =~ link.url
      assert html =~ link.hash
    end
  end
end
