defmodule Group2meetWeb.GroupLive do
  use Phoenix.LiveView, container: {:div, class: "contents"}

  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-2 gap-4 h-full p-4">
      <.live_component module={EventsPane} id="events_pane" group_id={@group_id} />
      <%= live_render(@socket, ChatPane, session: %{"group_id" => @group_id}, id: "chat_pane") %>
    </div>
    """
  end

  def mount(%{"group_id" => group_id}, %{}, socket) do
    if connected?(socket), do: Group2meetWeb.Endpoint.subscribe(group_id)

    socket = assign(socket, :group_id, group_id)
    {:ok, socket}
  end
end
