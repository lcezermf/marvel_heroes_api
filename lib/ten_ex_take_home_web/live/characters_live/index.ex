defmodule TenExTakeHomeWeb.CharactersLive.Index do
  use TenExTakeHomeWeb, :live_view

  require Logger

  alias TenExTakeHome.Heroes

  def mount(_params, _session, socket) do
    characters =
      if connected?(socket) do
        Heroes.get_characters()
      else
        []
      end

    socket =
      socket
      |> assign(:characters, characters)

    {:ok, socket}
  end
end
