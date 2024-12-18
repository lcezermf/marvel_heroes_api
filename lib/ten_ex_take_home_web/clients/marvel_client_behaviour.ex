defmodule TenExTakeHomeWeb.Clients.MarvelClientBehaviour do
  @moduledoc """
  Defines behaviour for Marvel API it allow us to later mock using Mox and
  define better tests. More info: https://elixirschool.com/en/lessons/testing/mox
  """

  @callback get_characters() :: {:ok, any()} | {:error, any()}
  @callback get_character(integer()) :: {:ok, any()} | {:error, any()}
  @callback get_comics(integer()) :: {:ok, any()} | {:error, any()}
  @callback get_events(integer()) :: {:ok, any()} | {:error, any()}
end
