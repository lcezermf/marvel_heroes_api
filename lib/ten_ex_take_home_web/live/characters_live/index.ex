defmodule TenExTakeHomeWeb.CharactersLive.Index do
  use TenExTakeHomeWeb, :live_view

  require Logger

  def mount(_params, _session, socket) do
    characters =
      if connected?(socket) do
        load_characters()
      else
        []
      end

    socket =
      socket
      |> assign(:characters, characters)

    {:ok, socket}
  end

  defp load_characters do
    case marvel_client().get_characters() do
      {:ok, characters} -> characters
      {:error, _} -> []
    end
  end

  defp marvel_client, do: Application.get_env(:ten_ex_take_home, :marvel_client)[:adapter]
end
