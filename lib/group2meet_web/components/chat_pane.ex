import CommonComponents

defmodule ChatPane do
  use Phoenix.Component

  def chat(assigns) do
    ~H"""
    <.pane>Chat</.pane>
    """
  end
end
