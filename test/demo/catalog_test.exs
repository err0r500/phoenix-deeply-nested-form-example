defmodule Demo.CatalogTest do
  use Demo.DataCase

  alias Demo.Catalog

  describe "performers" do
    alias Demo.Catalog.Performer

    import Demo.CatalogFixtures

    @invalid_attrs %{name: nil}

    test "list_performers/0 returns all performers" do
      performer = performer_fixture()
      assert Catalog.list_performers() == [performer]
    end

    test "get_performer!/1 returns the performer with given id" do
      performer = performer_fixture()
      assert Catalog.get_performer!(performer.id) == performer
    end

    test "create_performer/1 with valid data creates a performer" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Performer{} = performer} = Catalog.create_performer(valid_attrs)
      assert performer.name == "some name"
    end

    test "create_performer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_performer(@invalid_attrs)
    end

    test "update_performer/2 with valid data updates the performer" do
      performer = performer_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Performer{} = performer} = Catalog.update_performer(performer, update_attrs)
      assert performer.name == "some updated name"
    end

    test "update_performer/2 with invalid data returns error changeset" do
      performer = performer_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_performer(performer, @invalid_attrs)
      assert performer == Catalog.get_performer!(performer.id)
    end

    test "delete_performer/1 deletes the performer" do
      performer = performer_fixture()
      assert {:ok, %Performer{}} = Catalog.delete_performer(performer)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_performer!(performer.id) end
    end

    test "change_performer/1 returns a performer changeset" do
      performer = performer_fixture()
      assert %Ecto.Changeset{} = Catalog.change_performer(performer)
    end
  end

  describe "tracks" do
    alias Demo.Catalog.Track

    import Demo.CatalogFixtures

    @invalid_attrs %{name: nil}

    test "list_tracks/0 returns all tracks" do
      track = track_fixture()
      assert Catalog.list_tracks() == [track]
    end

    test "get_track!/1 returns the track with given id" do
      track = track_fixture()
      assert Catalog.get_track!(track.id) == track
    end

    test "create_track/1 with valid data creates a track" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Track{} = track} = Catalog.create_track(valid_attrs)
      assert track.name == "some name"
    end

    test "create_track/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_track(@invalid_attrs)
    end

    test "update_track/2 with valid data updates the track" do
      track = track_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Track{} = track} = Catalog.update_track(track, update_attrs)
      assert track.name == "some updated name"
    end

    test "update_track/2 with invalid data returns error changeset" do
      track = track_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_track(track, @invalid_attrs)
      assert track == Catalog.get_track!(track.id)
    end

    test "delete_track/1 deletes the track" do
      track = track_fixture()
      assert {:ok, %Track{}} = Catalog.delete_track(track)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_track!(track.id) end
    end

    test "change_track/1 returns a track changeset" do
      track = track_fixture()
      assert %Ecto.Changeset{} = Catalog.change_track(track)
    end
  end

  describe "albums" do
    alias Demo.Catalog.Album

    import Demo.CatalogFixtures

    @invalid_attrs %{name: nil}

    test "list_albums/0 returns all albums" do
      album = album_fixture()
      assert Catalog.list_albums() == [album]
    end

    test "get_album!/1 returns the album with given id" do
      album = album_fixture()
      assert Catalog.get_album!(album.id) == album
    end

    test "create_album/1 with valid data creates a album" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Album{} = album} = Catalog.create_album(valid_attrs)
      assert album.name == "some name"
    end

    test "create_album/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_album(@invalid_attrs)
    end

    test "update_album/2 with valid data updates the album" do
      album = album_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Album{} = album} = Catalog.update_album(album, update_attrs)
      assert album.name == "some updated name"
    end

    test "update_album/2 with invalid data returns error changeset" do
      album = album_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_album(album, @invalid_attrs)
      assert album == Catalog.get_album!(album.id)
    end

    test "delete_album/1 deletes the album" do
      album = album_fixture()
      assert {:ok, %Album{}} = Catalog.delete_album(album)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_album!(album.id) end
    end

    test "change_album/1 returns a album changeset" do
      album = album_fixture()
      assert %Ecto.Changeset{} = Catalog.change_album(album)
    end
  end
end
