defmodule TenExTakeHome.Cache do
  @moduledoc """
  A simple cache layer to avoid hitting marvel API for every request.
  """

  require Logger

  @table :marvel_heroes
  @expiry_in :timer.minutes(10)

  def start_link(table_name \\ @table) do
    if :ets.info(table_name) == :undefined do
      :ets.new(table_name, [:named_table, :public, :set])
    end

    {:ok, self()}
  end

  @doc """
  Get characters from a cache layer.

  Instead of calling API every time to get that, the API call is hidden into this module so
  if the cache exists and not expired it returns data, otherwise will retrieve data from API.

  Returns:
  - {:ok, data} - in case data is found in cache layer or it was a new retrive from API
  - :not_found - when no data is found
  """
  @spec get_characters :: {:ok, list()} | :not_found
  def get_characters(table \\ @table) do
    case get_characters_from_cache(table) do
      {:ok, characters} ->
        Logger.info("Getting characters data from cache layer")

        {:ok, characters}

      {:not_found, _} ->
        Logger.warn("No cache found from cache layer, getting data from API")

        get_characters_from_api(table)
    end
  end

  defp get_characters_from_cache(table) do
    current_time = System.system_time(:millisecond)

    case :ets.lookup(table, :characters) do
      [{:characters, characters, expiry}] ->
        if current_time < expiry do
          {:ok, characters}
        else
          :ets.delete(@table, :characters)
          {:not_found, []}
        end

      _ ->
        {:not_found, []}
    end
  end

  defp get_characters_from_api(table) do
    case marvel_client().get_characters() do
      {:ok, characters} ->
        expiry = System.system_time(:millisecond) + @expiry_in

        Logger.info("Inserting updated data from API into cache layer")

        :ets.insert(table, {:characters, characters, expiry})

        {:ok, characters}

      {:error, error} ->
        Logger.error("Error calling API")

        {:error, error}
    end
  end

  @doc """
  Get single character from a cache layer.

  Instead of calling API every time to get that, the API call is hidden into this module so
  if the cache exists and not expired it returns data, otherwise will retrieve data from API.

  Returns:
  - {:ok, data} - in case data is found in cache layer or it was a new retrive from API
  - :not_found - when no data is found
  """
  def get_character(table \\ @table, id) do
    case get_characters_from_cache(table, id) do
      {:ok, character} ->
        Logger.info("Getting character #{id} data from cache layer")

        {:ok, character}

      {:not_found, _} ->
        Logger.warn("No cache found from cache layer, getting data from API")

        get_characters_from_api(table, id)
    end
  end

  defp get_characters_from_cache(table, id) do
    current_time = System.system_time(:millisecond)

    case :ets.lookup(table, id) do
      [{id, character, expiry}] ->
        if current_time < expiry do
          {:ok, character}
        else
          :ets.delete(@table, id)
          {:not_found, nil}
        end

      _ ->
        {:not_found, nil}
    end
  end

  defp get_characters_from_api(table, id) do
    case marvel_client().get_character(id) do
      {:ok, character} ->
        expiry = System.system_time(:millisecond) + @expiry_in

        Logger.info("Inserting updated data from API into cache layer for a single id #{id}")

        :ets.insert(table, {id, character, expiry})

        {:ok, character}

      {:error, error} ->
        Logger.error("Error calling API")

        {:error, error}
    end
  end

  defp marvel_client, do: Application.get_env(:ten_ex_take_home, :marvel_client)[:adapter]
end
