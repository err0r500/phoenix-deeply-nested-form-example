defmodule DemoWeb.TrackLive.FormComponent do
  use DemoWeb, :live_component

  alias Demo.Catalog

  @doc """
  programmatic update :
  1. when filling the input named "to_add_performer_id", it sets the value in the assigns (with a dedicated validate function)
  2. when clicking on the button "add_performer", it pushes an "add_performer" event to the server
    the handler of this event assigns this value to true which causes a hidden input named "add_performer" to render
  3. this input has a phx-mounted callback setup that triggers a validate event with the name of the input used to pattern match on a dedicated validate function
  4. the validate function appends the value of assigns performer_id to the list of performers already present in the form, use the track_change function and updates the form
     it also passes the add performer to false so the hidden input disappears again (and will be remounted on next click so this pattern can be called several times)
  5. it causes the form to be re-rendered with the additionnal performer
  """

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

        <.label>Performers</.label>
        <.inputs_for :let={performer_ref} field={@form[:track_performers]}>
          <input type="hidden" name="track[performers_sort][]" value={performer_ref.index} />
          <div>
            <label>
              <button
                type="button"
                name="track[performers_drop][]"
                value={performer_ref.index}
                phx-click={JS.dispatch("change")}
              >
                <.icon name="hero-x-mark" />
              </button>
            </label>

            <div class="p-4">
              <input
                type="hidden"
                name={"track[track_performers][#{performer_ref.index}][performer_id]"}
                value={performer_ref[:performer_id].value}
              />
              <label>
                <% performer = @track_performers_details["#{performer_ref[:performer_id].value}"] %>
                <%= performer["name"] %>
              </label>
            </div>
          </div>
        </.inputs_for>

        <div class="flex justify-center gap-4">
          <%!-- <.button
            type="button"
            name="track[performers_sort][]"
            value="new"
            phx-click={JS.dispatch("change")}
          >
            Create new performer
          </.button> --%>
          <input
            :if={@add_performer}
            type="hidden"
            name="add_performer"
            phx-mounted={JS.dispatch("change")}
          />

          <.input type="text" name="to_add_performer_id" value="" />
          <.button
            type="button"
            id="add_performer"
            phx-click={JS.push("add_performer")}
            phx-target={@myself}
            disabled={@to_add_performer_id == ""}
          >
            Create
          </.button>

          <.button
            type="button"
            name="track[performers_sort][]"
            value="new"
            phx-click={JS.dispatch("change")}
          >
            Add existing performer
          </.button>
        </div>
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
     |> assign(
       :track_performers_details,
       Enum.reduce(track.track_performers, %{}, fn track_performer, acc ->
         Map.put(acc, "#{track_performer.performer_id}", %{
           "name" => track_performer.performer.name,
           "id" => track_performer.performer.id
         })
       end)
     )
     |> assign(add_performer: false)
     |> assign(to_add_performer_id: "")
     |> assign_new(:form, fn ->
       to_form(Catalog.change_track(track))
     end)}
  end

  @impl true
  def handle_event("validate", %{"add_performer" => _, "track" => track_params}, socket) do
    if socket.assigns.to_add_performer_id == "" do
      {:noreply, socket}
    else
      # updating the form
      track_params =
        Map.update!(track_params, "track_performers", fn track_performers ->
          Map.put(track_performers, "#{map_size(track_performers)}", %{
            "performer_id" => socket.assigns.to_add_performer_id
          })
        end)

      changeset =
        socket.assigns.track
        |> Catalog.change_track(track_params)

      # adding performer's details so they can be displayed
      track_performers_details =
        if not Map.has_key?(
             socket.assigns.track_performers_details,
             socket.assigns.to_add_performer_id
           ) do
          performer = Catalog.get_performer!(socket.assigns.to_add_performer_id)

          Map.put(socket.assigns.track_performers_details, "#{performer.id}", %{
            "name" => performer.name,
            "id" => performer.id
          })
        else
          socket.assigns.track_performers_details
        end

      {:noreply,
       socket
       |> assign(add_performer: false)
       |> assign(track_performers_details: track_performers_details)
       |> assign(form: to_form(changeset, action: :validate))}
    end
  end

  @impl true
  def handle_event("validate", %{"to_add_performer_id" => performer_id}, socket)
      when performer_id != "" do
    IO.inspect(performer_id, label: "adding performer_id")

    {:noreply,
     socket
     |> assign(to_add_performer_id: performer_id)}
  end

  @impl true
  def handle_event("validate", %{"track" => track_params} = _params, socket) do
    changeset = Catalog.change_track(socket.assigns.track, track_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"track" => track_params}, socket) do
    save_track(socket, socket.assigns.action, track_params)
  end

  def handle_event("add_performer", _params, socket) do
    {:noreply,
     socket
     |> assign(add_performer: true)
     |> assign(form: Map.put(socket.assigns.form, :action, :validate))}
  end

  defp save_track(socket, :new, track_params) do
    case Catalog.create_track(track_params) do
      {:ok, _track} ->
        {:noreply,
         socket
         |> put_flash(:info, "Track created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset, label: "creation failed")
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_track(socket, _, track_params) do
    case Catalog.update_track(socket.assigns.track, track_params) do
      {:ok, _track} ->
        {:noreply,
         socket
         |> put_flash(:info, "Track updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset, label: "edit failed")
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
