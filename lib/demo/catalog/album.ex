defmodule Demo.Catalog.Album do
  use Ecto.Schema
  import Ecto.Changeset

  schema "albums" do
    field :name, :string

    has_many :tracks, Demo.Catalog.Track, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(album, attrs) do
    album
    |> cast(attrs, [:name])
    |> cast_assoc(:tracks,
      with: &Demo.Catalog.Track.changeset/2,
      sort_param: :tracks_sort,
      drop_param: :tracks_drop,
      required: true
    )
    |> validate_required([:name], message: "Album name is required")
  end
end
