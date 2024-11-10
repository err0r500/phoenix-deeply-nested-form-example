defmodule Demo.Catalog.Performer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "performers" do
    field :name, :string

    belongs_to :track, Demo.Catalog.Track

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(performer, attrs) do
    performer
    |> cast(attrs, [:name])
    |> validate_required([:name], message: "Performer name is required")
  end
end
