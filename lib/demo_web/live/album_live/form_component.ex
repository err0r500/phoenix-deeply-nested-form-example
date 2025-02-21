defmodule DemoWeb.AlbumLive.FormComponent do
  use DemoWeb, :live_component
  require Logger

  alias Demo.Catalog

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage album records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="album-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} id="album_name" type="text" label="Album Name" phx-hook="Flush" />

        <.button phx-click="flush_name" type="button" phx-target={@myself}>flush name</.button>

        <.button
          phx-click={JS.dispatch("flush", to: "#album_name")}
          type="button"
          phx-target={@myself}
        >
          flush name working
        </.button>

        <.tracks_section tracks={@form[:tracks]} />

        <:actions>
          <.button phx-disable-with="Saving...">Save Album</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  attr :tracks, :list, required: true

  def tracks_section(assigns) do
    ~H"""
    <.label>Track list</.label>

    <.inputs_for :let={track} field={@tracks}>
      <input type="hidden" name="album[tracks_sort][]" value={track.index} />
      <input type="hidden" name={"album[tracks][#{track.index}][performers_drop][]"} />

      <div class="bg-yellow-100 p-4">
        <label>
          Track <%= track.index %>
          <button
            type="button"
            name="album[tracks_drop][]"
            value={track.index}
            phx-click={JS.dispatch("change")}
            class="float-right"
          >
            <.icon name="hero-trash" class="w-6 h-6" />
          </button>
        </label>

        <.input field={track[:name]} type="text" label="Track Name" />

        <.performers_section performers={track[:track_performers]} track_index={track.index} />
      </div>
    </.inputs_for>

    <div class="flex justify-center">
      <.button name="album[tracks_sort][]" value="new" phx-click={JS.dispatch("change")}>
        Add track
      </.button>
    </div>
    """
  end

  attr :performers, :list, required: true
  attr :track_index, :integer, required: true

  def performers_section(assigns) do
    ~H"""
    <.label>Performers</.label>

    <.inputs_for :let={performer} field={@performers}>
      <input
        type="hidden"
        name={"album[tracks][#{@track_index}][performers_sort][]"}
        value={performer.index}
      />

      <div class="bg-green-100 p-4 mb-4">
        <label>
          Performer <%= performer.index %>
          <button
            type="button"
            name={"album[tracks][#{@track_index}][performers_drop][]"}
            value={performer.index}
            phx-click={JS.dispatch("change")}
            class="float-right"
          >
            <.icon name="hero-trash" class="w-6 h-6" />
          </button>
        </label>

        <div class="bg-green-100 p-4">
          <.input field={performer[:name]} type="text" label="Performer Name" />
        </div>
      </div>
    </.inputs_for>

    <div class="flex justify-center ">
      <.button
        name={"album[tracks][#{@track_index}][performers_sort][]"}
        value="new"
        phx-click={JS.dispatch("change")}
      >
        Add performer
      </.button>
    </div>
    """
  end

  @impl true
  def update(%{album: album} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Catalog.change_album(album))
     end)}
  end

  @impl true
  def handle_event("validate", %{"album" => album_params}, socket) do
    changeset = Catalog.change_album(socket.assigns.album, album_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  @impl true
  def handle_event("flush_name", _value, socket) do
    IO.puts("handling flush event")
    JS.dispatch("flush", to: "#album_name")

    {:noreply, socket}
  end

  def handle_event("save", %{"album" => album_params}, socket) do
    save_album(socket, socket.assigns.action, album_params)
  end

  defp save_album(socket, :edit, album_params) do
    case Catalog.update_album(socket.assigns.album, album_params) do
      {:ok, album} ->
        notify_parent({:saved, album})

        {:noreply,
         socket
         |> put_flash(:info, "Album updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->

        Logger.error("save album, changeset #{inspect(changeset)}")
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_album(socket, :new, album_params) do
    case Catalog.create_album(album_params) do
      {:ok, album} ->
        notify_parent({:saved, album})

        {:noreply,
         socket
         |> put_flash(:info, "Album created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
