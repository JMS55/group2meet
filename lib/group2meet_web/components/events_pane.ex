import Group2meetWeb.CoreComponents

defmodule EventsPane do
  use Phoenix.Component

  def events_pane(assigns) do
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
    <.new_event_choice />
    """
  end

  defp new_event_start(assigns) do
    ~H"""
    <.event extra_classes="flex justify-center items-center gap-2">
      <p class="text-xl tracking-tight font-semibold">New Event</p>
      <.icon name="hero-plus" class="w-6 h-6" />
    </.event>
    """
  end

  defp new_event_choice(assigns) do
    ~H"""
    <.event extra_classes="flex justify-around">
      <p class="text-xl tracking-tight font-semibold">Deadline</p>
      <p class="text-xl tracking-tight font-semibold">Meeting</p>
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
