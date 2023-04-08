import Group2meetWeb.CoreComponents
import Pane

defmodule EventsPane do
  use Phoenix.Component

  def events_pane(assigns) do
    ~H"""
    <.pane>Events</.pane>
    """
  end
end
