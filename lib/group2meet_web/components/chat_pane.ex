import Group2meetWeb.CoreComponents

defmodule ChatPane do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="p-4 rounded-lg bg-white shadow-lg flex flex-col overflow-y-auto">
      <.message_history messages={[]} />
      <.chat_box />
    </div>
    """
  end

  def mount(_params, %{"group_id" => group_id}, socket) do
    socket = stream(socket, :messages, Group2meet.App.list_messages(group_id))
    {:ok, socket}
  end

  def message_history(assigns) do
    ~H"""
    <div class="flex flex-col gap-6 overflow-y-auto snap-y" id="messages" phx-update="stream">
      <.message :for={{dom_id, message} <- @messages} id={dom_id} username={message.user.name} contents={message.contents} />
    </div>
    """
  end

  def message(assigns) do
    ~H"""
    <div class="snap-center">
      <p class="text-md tracking-tight font-semibold"><%= @username %></p>
      <p><%= @contents %></p>
    </div>
    """
  end

  def chat_box(assigns) do
    ~H"""
    <.input name="chat-box" value="" />
    """
  end
end
