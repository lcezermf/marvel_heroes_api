defmodule TenExTakeHomeWeb.CharactersLive.IndexTest do
  use TenExTakeHomeWeb.ConnCase, async: true

  import Mox
  import Phoenix.LiveViewTest

  test "must render page with data loaded", %{conn: conn} do
    expect(marvel_client(), :get_characters, fn ->
      {:ok, [%{"id" => 1, "name" => "Name"}]}
    end)

    {:ok, view, html} = access_characters_page(conn)

    assert html =~ "Welcome to heroes page!"

    assert has_element?(view, "#character-#{1}")
  end

  test "must navigate to the details page when clicking a character link", %{conn: conn} do
    expiry = System.system_time(:millisecond) + :timer.minutes(1)

    expect(marvel_client(), :get_characters, fn ->
      {:ok,
       [
         %{
           "id" => 1,
           "name" => "Name",
           "description" => "This is a description",
           "comics" => %{"available" => 1},
           "events" => %{"available" => 2}
         }
       ]}
    end)

    expect(marvel_client(), :get_character, fn _ ->
      {:ok,
       %{
         "id" => 1,
         "name" => "Name",
         "description" => "This is a description",
         "comics" => %{"available" => 1},
         "events" => %{"available" => 2}
       }}
    end)

    :ets.insert(
      :marvel_heroes,
      {:characters,
       [
         %{
           "id" => 1,
           "name" => "Name",
           "description" => "This is a description",
           "comics" => %{"available" => 1},
           "events" => %{"available" => 2}
         }
       ], expiry}
    )

    :ets.insert(
      :marvel_heroes,
      {1,
       %{
         "id" => 1,
         "name" => "Name",
         "description" => "This is a description",
         "comics" => %{"available" => 1},
         "events" => %{"available" => 2}
       }, expiry}
    )

    {:ok, view, html} = access_characters_page(conn)

    assert html =~ "Name"

    {:ok, _show_view, show_html} =
      view
      |> element("a[href=\"/characters/1\"]")
      |> render_click()
      |> follow_redirect(conn, ~p"/characters/1")

    assert show_html =~ "Name"
  end

  defp marvel_client, do: Application.get_env(:ten_ex_take_home, :marvel_client)[:adapter]

  defp access_characters_page(conn) do
    conn
    |> get(~p"/characters")
    |> live()
  end
end
