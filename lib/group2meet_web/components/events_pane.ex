alias ElixirSense.Providers.Suggestion.Reducers.Common
import CommonComponents

defmodule EventsPane do
  use Phoenix.Component

  def events(assigns) do
    ~H"""
    <.pane>Events</.pane>
    """
  end
end
