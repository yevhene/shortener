defmodule ShortenerWeb.LinkLive.IndexTest do
  use ShortenerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Shortener.Factory

  alias Shortener.Links

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

    test "shortens link and resets form", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.link_index_path(conn, :index))

      url = "http://example.com/new"

      assert view
             |> element("#link-form")
             |> render_submit(link: %{url: url}) =~
               ~r{Your link.*#{url}.*is shortened to}s

      assert view
             |> element("#reset-form")
             |> render_click() =~ "link-form_url"
    end

    test "renders error on invalid data", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.link_index_path(conn, :index))

      assert view
             |> element("#link-form")
             |> render_submit(link: %{url: ""}) =~
               "can&#39;t be blank"
    end

    test "prepends link", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.link_index_path(conn, :index))

      url = "http://example.com/new"

      view
      |> element("#link-form")
      |> render_submit(link: %{url: url})

      assert view
             |> render() =~ ~r{<td>.*#{url}.*</td>}s
    end
  end
end
