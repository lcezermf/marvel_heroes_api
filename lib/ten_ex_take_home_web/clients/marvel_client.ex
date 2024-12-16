defmodule TenExTakeHomeWeb.Clients.MarvelClient do
  @moduledoc """
  Client to make requests to Marvel API.

  More info: https://developer.marvel.com/docs
  """

  require Logger

  @behaviour TenExTakeHomeWeb.Clients.MarvelClientBehaviour

  @impl true
  def get_characters do
    Logger.info("Calling get_characters/0")

    url = "#{base_url()}/characters"

    timestamp = :os.system_time(:second) |> Integer.to_string()
    hash = build_hash(timestamp)

    query_string =
      [
        ts: timestamp,
        apikey: public_key(),
        hash: hash
      ]
      |> URI.encode_query()

    case http_client().get("#{url}?#{query_string}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, decoded_response(body)}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, %{status_code: status_code, body: body}}

      {:error, error} ->
        {:error, error}
    end
  end

  defp build_hash(timestamp) do
    :crypto.hash(:md5, "#{timestamp}#{private_key()}#{public_key()}")
    |> Base.encode16(case: :lower)
  end

  defp decoded_response(response) do
    response
    |> Jason.decode!()
    |> Map.get("data")
    |> Map.get("results")
  end

  defp http_client, do: Application.get_env(:ten_ex_take_home, :http_client)
  defp base_url, do: Application.get_env(:ten_ex_take_home, :marvel_client)[:base_url]
  defp public_key, do: Application.get_env(:ten_ex_take_home, :marvel_client)[:public_key]
  defp private_key, do: Application.get_env(:ten_ex_take_home, :marvel_client)[:private_key]
end
