defmodule TenExTakeHome.Heroes do
  @moduledoc """
  Context to hold business logic
  """

  alias TenExTakeHome.Cache
  alias TenExTakeHome.Heroes.APIRequest
  alias TenExTakeHome.Repo

  @doc """
  Returns data for characters.

  It fetches the data from cache or API and return for the caller.

    Returns:
    - list with data: When API returns data
    - empty list when no data from API
  """
  @spec get_characters :: list()
  def get_characters do
    case Cache.get_characters() do
      {:error, _error} -> []
      {:ok, characters} -> characters
    end
  end

  @doc """
  Returns data for a single character.

  It fetches the data from cache or API and return for the caller.

    Returns:
    - a single record data
    - nil in case of not found
  """
  @spec get_character(integer()) :: any()
  def get_character(id) do
    case Cache.get_character(id) do
      {:error, _error} -> nil
      {:ok, character} -> character
    end
  end

  @doc """
  Returns data for a character comics.

  It fetches the data from cache or API and return for the caller.

    Returns:
    - list with data: When API returns data
    - empty list when no data from API
  """
  @spec get_comics(integer()) :: list()
  def get_comics(id) do
    case Cache.get_comics(id) do
      {:error, _error} -> []
      {:ok, comics} -> comics
    end
  end

  @doc """
  Returns data for a character events.

  It fetches the data from cache or API and return for the caller.

    Returns:
    - list with data: When API returns data
    - empty list when no data from API
  """
  @spec get_events(integer()) :: list()
  def get_events(id) do
    case Cache.get_events(id) do
      {:error, _error} -> []
      {:ok, events} -> events
    end
  end

  @doc """
  Creates a new record for APIRequest
  """
  @spec create_api_request(map()) :: {:ok, Ecto.Changeset.t()} | {:error, Ecto.Changeset.t()}
  def create_api_request(params) do
    %APIRequest{}
    |> APIRequest.changeset(params)
    |> Repo.insert()
  end
end
