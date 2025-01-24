defmodule Demo.Catalog.Track do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tracks" do
    field :name, :string

    belongs_to :album, Demo.Catalog.Album

    has_many :track_performers, Demo.Catalog.TrackPerformer,
      preload_order: [asc: :position],
      on_replace: :delete

    has_many :performers, through: [:track_performers, :performer]
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [:name])
    |> cast_assoc(:track_performers,
      with: &Demo.Catalog.TrackPerformer.changeset/3,
      sort_param: :performers_sort,
      drop_param: :performers_drop
    )
    |> validate_required([:name], message: "Track name is required")
  end
end
