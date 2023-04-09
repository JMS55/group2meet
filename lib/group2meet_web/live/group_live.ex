defmodule Group2meetWeb.GroupLive do
  use Phoenix.LiveView, container: {:div, class: "contents"}

  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-2 gap-4 h-full p-4">
      <%= live_render(@socket, EventsPane, session: %{"group_id" => @group_id}, id: "events_pane") %>
      <%= live_render(@socket, ChatPane, session: %{"group_id" => @group_id}, id: "chat_pane") %>
    </div>
    """
  end

  def mount(%{"group_id" => group_id}, %{}, socket) do
    group = Group2meet.App.get_group(group_id)
    socket = assign(socket, page_title: group.name)
    socket = assign(socket, :group_id, group_id)
    {:ok, socket}
  end
end
