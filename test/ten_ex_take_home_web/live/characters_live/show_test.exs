defmodule TenExTakeHomeWeb.CharactersLive.ShowTest do
  use TenExTakeHomeWeb.ConnCase, async: true

  import Mox
  import Phoenix.LiveViewTest

  describe "loads the page" do
    test "must render page with data loaded", %{conn: conn} do
      expect(marvel_client(), :get_character, fn _ ->
        {:ok, %{"id" => 1, "name" => "3-D Man", "description" => "This is a description"}}
      end)

      {:ok, _view, html} = access_characters_page(conn, 1)

      assert html =~ "3-D Man"
      assert html =~ "This is a description"
    end
  end

  describe "truncate/1" do
    test "must truncate the string" do
      long_string = String.duplicate("ok ", 50)

      truncated = TenExTakeHomeWeb.CharactersLive.Show.truncate(long_string, 10)

      assert truncated == "ok ok ok o..."
    end

    test "must return blank when empty string is given" do
      truncated = TenExTakeHomeWeb.CharactersLive.Show.truncate("", 10)

      assert truncated == ""
    end
  end

  defp marvel_client, do: Application.get_env(:ten_ex_take_home, :marvel_client)[:adapter]

  defp access_characters_page(conn, id) do
    conn
    |> get(~p"/characters/#{id}")
    |> live()
  end
end
