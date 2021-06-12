defmodule ShortenerWeb.RedirectControllerTest do
  use ShortenerWeb.ConnCase

  import Shortener.Factory

  defp create_link(_) do
    link = insert(:link)
    %{link: link}
  end

  describe "show" do
    setup [:create_link]

    test "redirects if link exists", %{conn: conn, link: link} do
      conn = get(conn, Routes.redirect_path(conn, :show, link.hash))
      assert redirected_to(conn, 302) =~ link.url
    end

    test "returns error if link not exists", %{conn: conn} do
      assert_error_sent 404, fn ->
        get(conn, Routes.redirect_path(conn, :show, "_wrong_"))
      end
    end
  end
end
