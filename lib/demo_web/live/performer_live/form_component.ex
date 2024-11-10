defmodule DemoWeb.PerformerLive.FormComponent do
  use DemoWeb, :live_component

  alias Demo.Catalog

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage performer records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="performer-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Performer</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{performer: performer} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Catalog.change_performer(performer))
     end)}
  end

  @impl true
  def handle_event("validate", %{"performer" => performer_params}, socket) do
    changeset = Catalog.change_performer(socket.assigns.performer, performer_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"performer" => performer_params}, socket) do
    save_performer(socket, socket.assigns.action, performer_params)
  end

  defp save_performer(socket, :edit, performer_params) do
    case Catalog.update_performer(socket.assigns.performer, performer_params) do
      {:ok, performer} ->
        notify_parent({:saved, performer})

        {:noreply,
         socket
         |> put_flash(:info, "Performer updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_performer(socket, :new, performer_params) do
    case Catalog.create_performer(performer_params) do
      {:ok, performer} ->
        notify_parent({:saved, performer})

        {:noreply,
         socket
         |> put_flash(:info, "Performer created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
