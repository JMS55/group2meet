defmodule EventsPane do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="p-4 rounded-lg bg-white shadow-lg flex flex-col overflow-y-auto">
      <.new_event />
      <.planners />
      <.events />
    </div>
    """
  end

  defp new_event(assigns) do
    ~H"""
    <.event extra_classes="flex justify-around">
      <button phx-click="new_deadline" class="text-xl tracking-tight font-semibold">Deadline</button>
      <button phx-click="new_meeting" class="text-xl tracking-tight font-semibold">Meeting</button>
    </.event>
    """
  end

  defp planners(assigns) do
    ~H"""

    """
  end

  defp events(assigns) do
    ~H"""

    """
  end

  slot(:inner_block)
  attr(:extra_classes, :string, default: "")

  defp event(assigns) do
    ~H"""
    <div class={"bg-zinc-50 p-6 mx-8 rounded-lg shadow #{@extra_classes}"}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
