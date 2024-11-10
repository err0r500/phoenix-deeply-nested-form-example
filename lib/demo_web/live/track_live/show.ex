defmodule DemoWeb.TrackLive.Show do
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
     |> assign(:track, Catalog.get_track!(id))}
  end

  defp page_title(:show), do: "Show Track"
  defp page_title(:edit), do: "Edit Track"
end
