defmodule TenExTakeHomeWeb.Clients.MarvelClient do
  @moduledoc """
  Client to make requests to Marvel API.

  More info: https://developer.marvel.com/docs
  """

  require Logger

  @behaviour TenExTakeHomeWeb.Clients.MarvelClientBehaviour

  @impl true
  def get_characters() do
    []
  end
end
