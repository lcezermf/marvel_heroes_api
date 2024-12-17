defmodule TenExTakeHome.Heroes.APIRequest do
  use Ecto.Schema

  import Ecto.Changeset

  schema "api_requests" do
    timestamps()
  end

  @doc false
  def changeset(api_request) do
    api_request
    |> cast(%{}, [])
  end
end
