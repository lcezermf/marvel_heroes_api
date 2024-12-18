defmodule TenExTakeHome.Repo.Migrations.AddUrlToApiRequest do
  use Ecto.Migration

  def change do
    alter table(:api_requests) do
      add :url, :string
    end
  end
end
