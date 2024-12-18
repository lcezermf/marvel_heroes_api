defmodule TenExTakeHomeWeb.CharactersLive.Show do
  @moduledoc """
  LiveView module to handle show the details for a single hero
  """

  use TenExTakeHomeWeb, :live_view

  require Logger

  alias TenExTakeHome.Heroes

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:character, nil)
      |> assign(:comics, [])
      |> assign(:events, [])
      |> assign(:active_tab, "events")

    {:ok, assign(socket, character: nil, active_tab: "comics")}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    character =
      id
      |> String.to_integer()
      |> Heroes.get_character()

    comics =
      id
      |> String.to_integer()
      |> Heroes.get_comics()

    events =
      id
      |> String.to_integer()
      |> Heroes.get_events()

    socket =
      socket
      |> assign(:character, character)
      |> assign(:comics, comics)
      |> assign(:events, events)

    {:noreply, socket}
  end

  @impl true
  def handle_event("select_tab", %{"tab" => tab}, socket) do
    socket =
      socket
      |> assign(:active_tab, tab)

    {:noreply, socket}
  end

  def truncate(_string, length \\ 100)

  def truncate("", _length), do: ""

  def truncate(nil, _length), do: ""

  def truncate(string, length) do
    string
    |> String.slice(0, length)
    |> String.trim_trailing()
    |> Kernel.<>("...")
  end

  def active_class(active_tab, tab) do
    if active_tab == tab do
      "border-b-2 border-blue-500 font-bold"
    else
      "text-gray-500"
    end
  end
end
