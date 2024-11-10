defmodule Demo.Repo.Migrations.CreatePerformers do
  use Ecto.Migration

  def change do
    create table(:performers) do
      add :name, :string

      add :track_id, references(:tracks, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:performers, [:track_id])
  end
end
