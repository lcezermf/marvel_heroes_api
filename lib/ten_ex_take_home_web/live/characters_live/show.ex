defmodule TenExTakeHomeWeb.CharactersLive.Show do
  @moduledoc """
  LiveView module to handle show the details for a single hero
  """

  use TenExTakeHomeWeb, :live_view

  require Logger

  alias TenExTakeHome.Heroes

  def handle_params(%{"id" => id}, _uri, socket) do
    character =
      id
      |> String.to_integer()
      |> Heroes.get_character()

    socket =
      socket
      |> assign(:character, character)

    {:noreply, socket}
  end

  def truncate(_string, length \\ 100)

  def truncate("", _length), do: ""

  def truncate(string, length) do
    string
    |> String.slice(0, length)
    |> String.trim_trailing()
    |> Kernel.<>("...")
  end
end
