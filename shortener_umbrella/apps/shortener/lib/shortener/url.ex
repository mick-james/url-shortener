defmodule Shortener.Url do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  schema "urls" do
    field :short_code, :string
    field :url, :string

    timestamps()
  end

  @fields [:short_code, :url]

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> validate_required([:short_code, :url])
    |> unique_constraint(:short_code)
  end
end


