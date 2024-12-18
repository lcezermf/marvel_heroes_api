defmodule TenExTakeHome.Heroes.APIRequest do
  use Ecto.Schema

  import Ecto.Changeset

  schema "api_requests" do
    field :url, :string, default: ""

    timestamps()
  end

  @doc false
  def changeset(api_request, attrs) do
    api_request
    |> cast(attrs, [:url])
  end
end
