defmodule Demo.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias Demo.Repo

  alias Demo.Catalog.Performer

  @doc """
  Returns the list of performers.

  ## Examples

      iex> list_performers()
      [%Performer{}, ...]

  """
  def list_performers do
    Repo.all(Performer)
  end

  @doc """
  Gets a single performer.

  Raises `Ecto.NoResultsError` if the Performer does not exist.

  ## Examples

      iex> get_performer!(123)
      %Performer{}

      iex> get_performer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_performer!(id), do: Repo.get!(Performer, id)

  @doc """
  Creates a performer.

  ## Examples

      iex> create_performer(%{field: value})
      {:ok, %Performer{}}

      iex> create_performer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_performer(attrs \\ %{}) do
    %Performer{}
    |> Performer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a performer.

  ## Examples

      iex> update_performer(performer, %{field: new_value})
      {:ok, %Performer{}}

      iex> update_performer(performer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_performer(%Performer{} = performer, attrs) do
    performer
    |> Performer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a performer.

  ## Examples

      iex> delete_performer(performer)
      {:ok, %Performer{}}

      iex> delete_performer(performer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_performer(%Performer{} = performer) do
    Repo.delete(performer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking performer changes.

  ## Examples

      iex> change_performer(performer)
      %Ecto.Changeset{data: %Performer{}}

  """
  def change_performer(%Performer{} = performer, attrs \\ %{}) do
    Performer.changeset(performer, attrs)
  end

  alias Demo.Catalog.Track

  @doc """
  Returns the list of tracks.

  ## Examples

      iex> list_tracks()
      [%Track{}, ...]

  """
  def list_tracks do
    Repo.all(Track)
  end

  @doc """
  Gets a single track.

  Raises `Ecto.NoResultsError` if the Track does not exist.

  ## Examples

      iex> get_track!(123)
      %Track{}

      iex> get_track!(456)
      ** (Ecto.NoResultsError)

  """
  def get_track!(id), do: Repo.get!(Track, id) |> Repo.preload(track_performers: [:performer])

  @doc """
  Creates a track.

  ## Examples

      iex> create_track(%{field: value})
      {:ok, %Track{}}

      iex> create_track(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_track(attrs \\ %{}) do
    %Track{}
    |> Track.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a track.

  ## Examples

      iex> update_track(track, %{field: new_value})
      {:ok, %Track{}}

      iex> update_track(track, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_track(%Track{} = track, attrs) do
    track
    |> Track.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a track.

  ## Examples

      iex> delete_track(track)
      {:ok, %Track{}}

      iex> delete_track(track)
      {:error, %Ecto.Changeset{}}

  """
  def delete_track(%Track{} = track) do
    Repo.delete(track)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking track changes.

  ## Examples

      iex> change_track(track)
      %Ecto.Changeset{data: %Track{}}

  """
  def change_track(%Track{} = track, attrs \\ %{}) do
    Track.changeset(track, attrs)
  end

  alias Demo.Catalog.Album

  @doc """
  Returns the list of albums.

  ## Examples

      iex> list_albums()
      [%Album{}, ...]

  """
  def list_albums do
    Repo.all(Album)
  end

  @doc """
  Gets a single album.

  Raises `Ecto.NoResultsError` if the Album does not exist.

  ## Examples

      iex> get_album!(123)
      %Album{}

      iex> get_album!(456)
      ** (Ecto.NoResultsError)

  """
  def get_album!(id), do: Repo.get!(Album, id) |> Repo.preload(tracks: [:performers])

  @doc """
  Creates a album.

  ## Examples

      iex> create_album(%{field: value})
      {:ok, %Album{}}

      iex> create_album(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_album(attrs \\ %{}) do
    %Album{}
    |> Album.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a album.

  ## Examples

      iex> update_album(album, %{field: new_value})
      {:ok, %Album{}}

      iex> update_album(album, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_album(%Album{} = album, attrs) do
    album
    |> Album.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a album.

  ## Examples

      iex> delete_album(album)
      {:ok, %Album{}}

      iex> delete_album(album)
      {:error, %Ecto.Changeset{}}

  """
  def delete_album(%Album{} = album) do
    Repo.delete(album)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking album changes.

  ## Examples

      iex> change_album(album)
      %Ecto.Changeset{data: %Album{}}

  """
  def change_album(%Album{} = album, attrs \\ %{}) do
    Album.changeset(album, attrs)
  end
end
