defmodule TenExTakeHomeWeb.Clients.MarvelClient do
  @moduledoc """
  Client to make requests to Marvel API.

  More info: https://developer.marvel.com/docs
  """

  require Logger

  alias TenExTakeHome.Heroes

  @behaviour TenExTakeHomeWeb.Clients.MarvelClientBehaviour

  @doc """
  Fetches a list of Marvel characters from the Marvel API.

  This function performs an HTTP GET request to the Marvel API `/characters` endpoint using the configured HTTP client.
  It includes the required query parameters for authentication: `ts` (timestamp), `apikey` (public API key), and `hash` (MD5 hash of the timestamp, private key, and public key).

  Returns:
    - `{:ok, response}`: When the request is successful, where `response` is the decoded response body.
    - `{:error, %{status_code: status_code, body: body}}`: When the request fails with a non-200 status code, where `status_code` and `body` describe the error.
    - `{:error, error}`: When an HTTP error occurs, where `error` contains the error details.
  """
  @impl true
  @spec get_characters() :: {:error, any()} | {:ok, any()}
  def get_characters do
    Logger.info("Calling get_characters/0 from MarvelClient")

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
        Logger.info("Success getting data from API")

        Heroes.create_api_request(%{url: url})

        {:ok, decoded_response(body)}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        Logger.error("Error getting data from API. code: #{status_code}, body: #{inspect(body)}")

        {:error, %{status_code: status_code, body: body}}

      {:error, error} ->
        Logger.error("Error getting data from API. error: #{inspect(error)}")

        {:error, error}
    end
  end

  @doc """
  Fetches a single resource of Marvel characters from the Marvel API.

  This function performs an HTTP GET request to the Marvel API `/characters/id` endpoint using the configured HTTP client.
  It includes the required query parameters for authentication: `ts` (timestamp), `apikey` (public API key), and `hash` (MD5 hash of the timestamp, private key, and public key).

  Returns:
    - `{:ok, response}`: When the request is successful, where `response` is the decoded response body.
    - `{:error, %{status_code: status_code, body: body}}`: When the request fails with a non-200 status code, where `status_code` and `body` describe the error.
    - `{:error, error}`: When an HTTP error occurs, where `error` contains the error details.
  """
  @impl true
  @spec get_character(integer()) :: {:ok, any()} | {:error, any()}
  def get_character(id) do
    Logger.info("Calling get_character/1 from MarvelClient with id: #{id}")

    url = "#{base_url()}/characters/#{id}"

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
        Logger.info("Success getting data from API")

        Heroes.create_api_request(%{url: url})

        {:ok, List.first(decoded_response(body))}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        Logger.error("Error getting data from API. code: #{status_code}, body: #{inspect(body)}")

        {:error, %{status_code: status_code, body: body}}

      {:error, error} ->
        Logger.error("Error getting data from API. error: #{inspect(error)}")

        {:error, error}
    end
  end

  @doc """
  Fetches a list of Marvel comics for a given hero from the Marvel API.

  This function performs an HTTP GET request to the Marvel API `/characters` endpoint using the configured HTTP client.
  It includes the required query parameters for authentication: `ts` (timestamp), `apikey` (public API key), and `hash` (MD5 hash of the timestamp, private key, and public key).

  Returns:
    - `{:ok, response}`: When the request is successful, where `response` is the decoded response body.
    - `{:error, %{status_code: status_code, body: body}}`: When the request fails with a non-200 status code, where `status_code` and `body` describe the error.
    - `{:error, error}`: When an HTTP error occurs, where `error` contains the error details.
  """
  @impl true
  @spec get_comics(integer()) :: {:error, any()} | {:ok, any()}
  def get_comics(id) do
    Logger.info("Calling get_comics/1 from MarvelClient with id: #{id}")

    url = "#{base_url()}/characters/#{id}/comics"

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
        Logger.info("Success getting data from API")

        Heroes.create_api_request(%{url: url})

        {:ok, decoded_response(body)}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        Logger.error("Error getting data from API. code: #{status_code}, body: #{inspect(body)}")

        {:error, %{status_code: status_code, body: body}}

      {:error, error} ->
        Logger.error("Error getting data from API. error: #{inspect(error)}")

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
