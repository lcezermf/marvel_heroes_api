defmodule TenExTakeHome.Repo.Migrations.CreateApiRequests do
  use Ecto.Migration

  def change do
    create table(:api_requests) do
      timestamps()
    end
  end
end
