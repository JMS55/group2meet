defmodule CommonComponents do
  use Phoenix.Component

  def pane(assigns) do
    ~H"""
    <div class="p-4 rounded-lg bg-white shadow-lg">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
