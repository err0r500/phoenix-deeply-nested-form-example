defmodule DemoWeb.TrackLive.FormComponent do
  use DemoWeb, :live_component

  alias Demo.Catalog

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage track records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="track-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Track</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{track: track} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Catalog.change_track(track))
     end)}
  end

  @impl true
  def handle_event("validate", %{"track" => track_params}, socket) do
    changeset = Catalog.change_track(socket.assigns.track, track_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"track" => track_params}, socket) do
    save_track(socket, socket.assigns.action, track_params)
  end

  defp save_track(socket, :edit, track_params) do
    case Catalog.update_track(socket.assigns.track, track_params) do
      {:ok, track} ->
        notify_parent({:saved, track})

        {:noreply,
         socket
         |> put_flash(:info, "Track updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_track(socket, :new, track_params) do
    case Catalog.create_track(track_params) do
      {:ok, track} ->
        notify_parent({:saved, track})

        {:noreply,
         socket
         |> put_flash(:info, "Track created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
