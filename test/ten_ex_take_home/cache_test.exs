defmodule TenExTakeHome.CacheTest do
  # use TenExTakeHome.DataCase

  # import Mox

  # alias TenExTakeHome.Cache

  # @table :test_marvel_heroes

  # setup do
  #   IO.inspect("he")
  #   Cache.start_link(@table)

  #   :ets.delete_all_objects(@table)

  #   :ok
  # end

  # describe "get_characters/0" do
  #   test "must return cached data when that is valid" do
  #     expiry = System.system_time(:millisecond) + :timer.minutes(1)
  #     :ets.insert(@table, {:characters, ["One", "Two"], expiry})

  #     assert {:ok, ["One", "Two"]} = Cache.get_characters()
  #   end

  #   test "must fetches data from API and caches it there is no cache" do
  #     expect(marvel_client(), :get_characters, fn ->
  #       {:ok, [%{"id" => 1, "name" => "One"}, %{"id" => 2, "name" => "Two"}]}
  #     end)

  #     assert {:ok, result} = Cache.get_characters()

  #     assert [{:characters, ^result, _expiry}] = :ets.lookup(:marvel_heroes, :characters)
  #   end

  #   test "fetches data from API and updates cache if cache is expired" do
  #     expired_time = System.system_time(:millisecond) - 1

  #     :ets.insert(
  #       @table,
  #       {:characters, [%{"id" => 1, "name" => "One"}, %{"id" => 2, "name" => "Two"}],
  #        expired_time}
  #     )

  #     expect(marvel_client(), :get_characters, fn ->
  #       {:ok, [%{"id" => 3, "name" => "Three"}, %{"id" => 4, "name" => "Four"}]}
  #     end)

  #     assert {:ok, result} = Cache.get_characters()
  #     assert result == [%{"id" => 3, "name" => "Three"}, %{"id" => 4, "name" => "Four"}]
  #     assert [{:characters, ^result, _expiry}] = :ets.lookup(:marvel_heroes, :characters)
  #   end

  #   test "returns an error when the API call fails" do
  #     expect(marvel_client(), :get_characters, fn ->
  #       {:error, "error"}
  #     end)

  #     assert {:error, "error"} = Cache.get_characters()
  #   end
  # end

  # defp marvel_client, do: Application.get_env(:ten_ex_take_home, :marvel_client)[:adapter]
end
