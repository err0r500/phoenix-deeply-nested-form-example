defmodule Demo.Repo.Migrations.CreatePerformers do
  use Ecto.Migration

  def change do
    create table(:performers) do
      add :name, :string

      add :track_id, references(:tracks, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:performers, [:track_id])

    create table(:track_performers) do
      add :track_id, references(:tracks)
      add :performer_id, references(:performers)
      add :position, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:track_performers, [:track_id, :performer_id])
  end
end
