defmodule Demo.Repo.Migrations.CreateTracks do
  use Ecto.Migration

  def change do
    create table(:tracks) do
      add :name, :string

      add :album_id, references(:albums, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:tracks, [:album_id])
  end
end
