defmodule TenExTakeHome.Heroes do
  @moduledoc """
  Context to hold business logic
  """

  alias TenExTakeHome.Cache
  alias TenExTakeHome.Heroes.APIRequest
  alias TenExTakeHome.Repo

  @doc """
  Returns data for characters.

  It fetches the data from API and return for the caller.

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
  Creates a new record for APIRequest
  """
  @spec create_api_request :: {:ok, Ecto.Changeset.t()} | {:error, Ecto.Changeset.t()}
  def create_api_request do
    APIRequest.changeset(%APIRequest{})
    |> Repo.insert()
  end
end
