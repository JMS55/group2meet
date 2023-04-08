import EventsPane
import ChatPane

defmodule Group2meetWeb.GroupLive do
  use Phoenix.LiveView, container: {:tr, class: "colorized"}

  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-2 gap-4 h-full p-4">
      <.events />
      <.chat />
    </div>
    """
  end

  def mount(%{"group_id" => group_id}, %{}, socket) do
    socket = assign(socket, :group_id, group_id)
    {:ok, socket}
  end
end
