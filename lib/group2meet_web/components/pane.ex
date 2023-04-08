defmodule Pane do
  use Phoenix.Component

  slot(:inner_block)
  attr(:extra_classes, :string, default: "")

  def pane(assigns) do
    ~H"""
    <div class={"p-4 rounded-lg bg-white shadow-lg #{@extra_classes}"}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
