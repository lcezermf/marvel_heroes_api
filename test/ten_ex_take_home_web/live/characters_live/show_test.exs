defmodule TenExTakeHomeWeb.CharactersLive.ShowTest do
  use TenExTakeHomeWeb.ConnCase, async: true

  alias TenExTakeHomeWeb.CharactersLive.Show

  import Mox
  import Phoenix.LiveViewTest

  test "must render page with data loaded", %{conn: conn} do
    expect(marvel_client(), :get_character, fn _ ->
      {:ok,
       %{
         "id" => 1,
         "name" => "3-D Man",
         "description" => "This is a description",
         "comics" => %{"available" => 10},
         "events" => %{"available" => 12}
       }}
    end)

    {:ok, view, html} = access_characters_page(conn, 1)

    assert html =~ "3-D Man"
    assert html =~ "This is a description"

    assert has_element?(view, "#comics-tab-character-1 > span", "10")
    assert has_element?(view, "#events-tab-character-1 > span", "12")
  end

  test "must change selected tab", %{conn: conn} do
    expect(marvel_client(), :get_character, fn _ ->
      {:ok,
       %{
         "id" => 1,
         "name" => "3-D Man",
         "description" => "This is a description",
         "comics" => %{"available" => 10},
         "events" => %{"available" => 10}
       }}
    end)

    {:ok, view, html} = access_characters_page(conn, 1)

    assert html =~ "3-D Man"
    assert html =~ "This is a description"

    # comics is active by default
    assert has_element?(view, "#comics-tab-character-1.border-blue-500")

    view
    |> element("#events-tab-character-1")
    |> render_click()

    # Change active tab
    refute has_element?(view, "#comics-tab-character-1.border-blue-500")
    assert has_element?(view, "#events-tab-character-1.border-blue-500")

    view
    |> element("#comics-tab-character-1")
    |> render_click()

    # Change active tab
    refute has_element?(view, "#events-tab-character-1.border-blue-500")
    assert has_element?(view, "#comics-tab-character-1.border-blue-500")
  end

  describe "truncate/1" do
    test "must truncate the string" do
      long_string = String.duplicate("ok ", 50)

      truncated = Show.truncate(long_string, 10)

      assert truncated == "ok ok ok o..."
    end

    test "must return blank when empty string is given" do
      truncated = Show.truncate("", 10)

      assert truncated == ""
    end
  end

  describe "active_tab/2" do
    test "must return class with activation" do
      result = Show.active_class("tab1", "tab1")

      assert result == "border-b-2 border-blue-500 font-bold"
    end

    test "must return class with no activation" do
      result = Show.active_class("tab1", "tab2")

      assert result == "text-gray-500"
    end
  end

  defp marvel_client, do: Application.get_env(:ten_ex_take_home, :marvel_client)[:adapter]

  defp access_characters_page(conn, id) do
    conn
    |> get(~p"/characters/#{id}")
    |> live()
  end
end