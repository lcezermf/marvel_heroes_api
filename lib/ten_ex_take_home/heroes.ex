defmodule TenExTakeHome.Heroes do
  @moduledoc """
  Context to hold business logic
  """

  @doc """
  Returns data for characters.

  It fetches the data from API and return for the caller.

    Returns:
    - list with data: When API returns data
    - empty list when no data from API
  """
  @spec get_characters :: list()
  def get_characters do
    case marvel_client().get_characters() do
      {:ok, characters} -> characters
      {:error, _} -> []
    end
  end

  defp marvel_client, do: Application.get_env(:ten_ex_take_home, :marvel_client)[:adapter]
end
