defmodule Demo.Repo.Migrations.CreateAlbums do
  use Ecto.Migration

  def change do
    create table(:albums) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
