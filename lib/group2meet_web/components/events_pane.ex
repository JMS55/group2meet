alias ElixirSense.Providers.Suggestion.Reducers.Common
import Pane

defmodule EventsPane do
  use Phoenix.Component

  def events_pane(assigns) do
    ~H"""
    <.pane>Events</.pane>
    """
  end
end
