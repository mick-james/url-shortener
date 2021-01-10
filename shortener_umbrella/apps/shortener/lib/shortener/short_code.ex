defmodule Shortener.ShortCode do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  schema "short_codes" do
    field :short_code, :string
    field :value, :string

    timestamps()
  end

  @fields [:short_code, :value]

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> validate_required([:short_code, :value])
    |> unique_constraint(:short_code)
  end
end


