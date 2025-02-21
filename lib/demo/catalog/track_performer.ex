defmodule Demo.Catalog.TrackPerformer do
  use Ecto.Schema
  import Ecto.Changeset

  alias Demo.Catalog.{Track, Performer}

  schema "track_performers" do
    field :position, :integer
    belongs_to :track, Track, primary_key: true
    belongs_to :performer, Performer, primary_key: true
    timestamps(type: :utc_datetime)
  end

  def changeset(track_performer, attrs, position) do
    track_performer
    |> cast(attrs, [:track_id, :performer_id, :position])
    |> validate_required([:track_id, :performer_id])
    |> change(position: position)
    |> unique_constraint([:track, :performer])
  end
end
