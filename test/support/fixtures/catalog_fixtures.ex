defmodule Demo.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Demo.Catalog` context.
  """

  @doc """
  Generate a performer.
  """
  def performer_fixture(attrs \\ %{}) do
    {:ok, performer} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Demo.Catalog.create_performer()

    performer
  end

  @doc """
  Generate a track.
  """
  def track_fixture(attrs \\ %{}) do
    {:ok, track} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Demo.Catalog.create_track()

    track
  end

  @doc """
  Generate a album.
  """
  def album_fixture(attrs \\ %{}) do
    {:ok, album} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Demo.Catalog.create_album()

    album
  end
end
