defmodule Shortener.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :short_code, :string
      add :url, :string

      timestamps()
    end

    create unique_index(:urls, [:short_code])
  end
end
