defmodule BarquinhosWeb.PageLiveTest do
  use BarquinhosWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to Barquinhos"
    assert render(page_live) =~ "Welcome to Barquinhos"
  end
end
