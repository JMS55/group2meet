import Group2meetWeb.CoreComponents
import Pane

defmodule ChatPane do
  use Phoenix.Component

  def chat_pane(assigns) do
    ~H"""
    <.pane extra_classes="flex flex-col overflow-y-auto">
      <.message_history />
      <.chat_box />
    </.pane>
    """
  end

  def message_history(assigns) do
    ~H"""
    <div class="flex flex-col gap-6 overflow-y-auto snap-y">
      <.message username="Jasmine" message={lorem_ipsum()} />
      <.message username="Justin" message={lorem_ipsum()} />
      <.message username="Caleb" message={lorem_ipsum()} />
      <.message username="Jasmine" message={lorem_ipsum()} />
      <.message username="Justin" message={lorem_ipsum()} />
      <.message username="Caleb" message={lorem_ipsum()} />
      <.message username="Jasmine" message={lorem_ipsum()} />
      <.message username="Justin" message={lorem_ipsum()} />
      <.message username="Caleb" message={lorem_ipsum()} />
    </div>
    """
  end

  def message(assigns) do
    ~H"""
    <div class="snap-center">
      <p class="text-md tracking-tight font-semibold"><%= @username %></p>
      <p><%= @message %></p>
    </div>
    """
  end

  def chat_box(assigns) do
    ~H"""
    <.input name="chat-box" value="" />
    """
  end

  def lorem_ipsum() do
    "Asperiores et ex temporibus id minus officia quis. Tempora aliquam doloremque consectetur incidunt recusandae sed consequuntur molestiae. Dolorum delectus nisi animi labore autem voluptas. Voluptatem ratione quas eum ex reiciendis ut. Tempore ea explicabo autem."
  end
end
