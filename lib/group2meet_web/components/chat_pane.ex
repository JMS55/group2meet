import Group2meetWeb.CoreComponents

defmodule ChatPane do
  use Phoenix.LiveView, container: {:div, class: "contents"}

  def render(assigns) do
    ~H"""
    <div class="p-4 rounded-lg bg-white shadow-lg flex flex-col justify-end overflow-y-auto text-lg">
      <.message_history messages={@streams.messages} />
      <.chat_box form={@form} />
    </div>
    """
  end

  def mount(_params, %{"group_id" => group_id}, socket) do
    if connected?(socket), do: Group2meetWeb.Endpoint.subscribe(group_id)

    socket = assign(socket, group_id: group_id)
    socket = stream(socket, :messages, Group2meet.App.get_messages(group_id))
    socket = assign(socket, form: %Group2meet.Message{} |> Ecto.Changeset.change() |> to_form())

    {:ok, socket}
  end

  def handle_event("send_message", %{"message" => params}, socket) do
    {:ok, message} = Group2meet.App.create_message(params, socket.assigns.group_id, 1)
    Group2meetWeb.Endpoint.broadcast(socket.assigns.group_id, "new_message", message)

    socket = assign(socket, form: %Group2meet.Message{} |> Ecto.Changeset.change() |> to_form())
    socket = push_event(socket, "clear", %{})
    {:noreply, socket}
  end

  def handle_info(%{event: "new_message", payload: message}, socket) do
    socket = stream_insert(socket, :messages, message)
    {:noreply, socket}
  end

  defp message_history(assigns) do
    ~H"""
    <div
      class="flex flex-col gap-6 overflow-y-auto snap-y"
      id="messages"
      phx-update="stream"
      phx-hook="KeepScrolledToBottom"
    >
      <.message :for={{dom_id, message} <- @messages} id={dom_id} message={message} />
    </div>
    """
  end

  defp message(assigns) do
    ~H"""
    <div class="snap-center">
      <p class="tracking-tight font-semibold"><%= @message.user.name %></p>
      <p class="text-md break-words"><%= @message.contents %></p>
    </div>
    """
  end

  defp chat_box(assigns) do
    ~H"""
    <.form for={@form} phx-submit="send_message">
      <.input field={@form[:contents]} phx-hook="Clear" />
    </.form>
    """
  end
end
