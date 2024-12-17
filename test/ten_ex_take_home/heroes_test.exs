defmodule TenExTakeHome.HeroesTest do
  use TenExTakeHome.DataCase, async: true

  import Mox

  alias TenExTakeHome.Heroes

  setup :verify_on_exit!

  describe "get_characters" do
    test "must return a list of data" do
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

    test "must return empty list when no data to fetch" do
      :ets.delete(:marvel_heroes, :characters)

      # when cache does not exists it tries to get data from API
      expect(marvel_client(), :get_characters, fn ->
        {:error, "error"}
      end)

      results = Heroes.get_characters()

      assert Enum.empty?(results)
    end
  end

  describe "get_character/1" do
    test "must return a single character" do
      expiry = System.system_time(:millisecond) + :timer.minutes(1)

      :ets.insert(
        :marvel_heroes,
        {1, %{"id" => 1, "name" => "Name"}, expiry}
      )

      result = Heroes.get_character(1)

      refute is_nil(result)
      assert result["id"] == 1
      assert result["name"] == "Name"
    end

    test "must return nil when no data found" do
      :ets.delete(:marvel_heroes, 1)

      # when cache does not exists it tries to get data from API
      expect(marvel_client(), :get_character, fn _ ->
        {:error, "error"}
      end)

      result = Heroes.get_character(1)

      assert is_nil(result)
    end
  end

  describe "create_api_request/0" do
    test "must create a new record of api request" do
      {:ok, %TenExTakeHome.Heroes.APIRequest{} = _api_request} = Heroes.create_api_request()
    end
  end

  defp marvel_client, do: Application.get_env(:ten_ex_take_home, :marvel_client)[:adapter]
end
