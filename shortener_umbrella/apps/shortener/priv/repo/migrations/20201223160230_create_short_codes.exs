defmodule Shortener.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:short_codes) do
      add :short_code, :string
      add :value, :string

      timestamps()
    end

    create unique_index(:short_codes, [:short_code])
  end
end
