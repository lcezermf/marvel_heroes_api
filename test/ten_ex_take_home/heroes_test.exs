defmodule TenExTakeHome.HeroesTest do
  use TenExTakeHome.DataCase, async: true

  import Mox

  alias TenExTakeHome.Heroes

  setup :verify_on_exit!

  describe "get_characters" do
    test "must return a list with data when API returns data" do
      expiry = System.system_time(:millisecond) + :timer.minutes(1)

      :ets.insert(
        :marvel_heroes,
        {:characters, [%{"id" => 1, "name" => "Name"}], expiry}
      )

      [result | _] = results = Heroes.get_characters()

      refute Enum.empty?(results)
      assert result["id"] == 1
      assert result["name"] == "Name"
    end

    test "must return an empty list when API returns no data or error" do
      :ets.delete(:marvel_heroes, :characters)

      # when cache does not exists it tries to get data from API
      expect(marvel_client(), :get_characters, fn ->
        {:error, "error"}
      end)

      results = Heroes.get_characters()

      assert Enum.empty?(results)
    end
  end

  defp marvel_client, do: Application.get_env(:ten_ex_take_home, :marvel_client)[:adapter]
end
