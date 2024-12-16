defmodule TenExTakeHomeWeb.Clients.MarvelClientTest do
  use TenExTakeHomeWeb.ConnCase, async: true

  import Mox

  alias TenExTakeHomeWeb.Clients.MarvelClient

  describe "get_characters/0" do
    test "must return empyt list" do
      expect(marvel_client(), :get_characters, fn ->
        {:ok, %HTTPoison.Response{status_code: 200}}
      end)

      assert Enum.empty?(MarvelClient.get_characters())
    end
  end

  defp marvel_client, do: Application.get_env(:ten_ex_take_home, :marvel_client)[:adapter]
end
