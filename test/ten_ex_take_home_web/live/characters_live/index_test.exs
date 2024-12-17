defmodule TenExTakeHomeWeb.CharactersLive.IndexTest do
  use TenExTakeHomeWeb.ConnCase, async: true

  import Mox
  import Phoenix.LiveViewTest

  describe "loads the page" do
    test "must render page with data loaded", %{conn: conn} do
      expect(marvel_client(), :get_characters, fn ->
        {:ok, [%{"id" => 1, "name" => "3-D Man"}]}
      end)

      {:ok, view, html} = access_characters_page(conn)

      assert html =~ "Welcome to heroes page!"

      assert has_element?(view, "#character-#{1}")
    end
  end

  test "must navigate to the details page when clicking a character link", %{conn: conn} do
    expect(marvel_client(), :get_characters, fn ->
      {:ok, [%{"id" => 1, "name" => "3-D Man"}]}
    end)

    {:ok, view, html} = access_characters_page(conn)

    assert html =~ "3-D Man"

    {:ok, _details_view, show_html} =
      view
      |> element("a[href=\"/characters/1\"]")
      |> render_click()
      |> follow_redirect(conn, ~p"/characters/1")

    assert show_html =~ "3-D Man"
  end

  defp marvel_client, do: Application.get_env(:ten_ex_take_home, :marvel_client)[:adapter]

  defp access_characters_page(conn) do
    conn
    |> get(~p"/characters")
    |> live()
  end
end
