defmodule Demo.Catalog.Performer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "performers" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(performer, attrs) do
    performer
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
