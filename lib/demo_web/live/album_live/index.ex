defmodule DemoWeb.AlbumLive.Index do
  use DemoWeb, :live_view

  alias Demo.Catalog
  alias Demo.Catalog.Album

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :albums, Catalog.list_albums())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Album")
    |> assign(:album, Catalog.get_album!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Album")
    |> assign(:album, %Album{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Albums")
    |> assign(:album, nil)
  end

  @impl true
  def handle_info({DemoWeb.AlbumLive.FormComponent, {:saved, album}}, socket) do
    {:noreply, stream_insert(socket, :albums, album)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    album = Catalog.get_album!(id)
    {:ok, _} = Catalog.delete_album(album)

    {:noreply, stream_delete(socket, :albums, album)}
  end
end
