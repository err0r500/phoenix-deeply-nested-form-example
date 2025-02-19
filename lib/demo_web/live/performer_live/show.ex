defmodule DemoWeb.PerformerLive.Show do
  use DemoWeb, :live_view

  alias Demo.Catalog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:performer, Catalog.get_performer!(id))}
  end

  defp page_title(:show), do: "Show Performer"
  defp page_title(:edit), do: "Edit Performer"
end
