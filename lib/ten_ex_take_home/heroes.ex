defmodule TenExTakeHome.Heroes do
  @moduledoc """
  Context to hold business logic
  """

  alias TenExTakeHome.Cache

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
end
