defmodule Demo.Catalog.Track do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tracks" do
    field :name, :string

    belongs_to :album, Demo.Catalog.Album
    has_many :performers, Demo.Catalog.Performer, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [:name])
    |> cast_assoc(:performers,
      with: &Demo.Catalog.Performer.changeset/2,
      sort_param: :performers_sort,
      drop_param: :performers_drop
    )
    |> validate_required([:name], message: "Track name is required")
  end
end
