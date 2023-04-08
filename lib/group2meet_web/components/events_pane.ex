alias Group2meetWeb.CoreComponents
import CoreComponents

defmodule EventsPane do
  use Phoenix.LiveView, container: {:div, class: "contents"}

  def render(assigns) do
    ~H"""
    <div class="p-4 rounded-lg bg-white shadow-lg flex flex-col gap-4 overflow-y-auto">
      <.in_progress_event in_progress_event={@in_progress_event} />
      <.new_event />
      <.planners />
      <.events deadlines={@deadlines} />
    </div>
    """
  end

  def mount(_params, %{"group_id" => group_id}, socket) do
    socket = assign(socket, group_id: group_id)
    socket = assign(socket, in_progress_event: nil)
    socket = assign(socket, deadlines: Group2meet.App.get_deadlines(group_id))

    {:ok, socket}
  end

  def handle_event("new_deadline", _, socket) do
    socket =
      if socket.assigns.in_progress_event == nil do
        assign(socket,
          in_progress_event:
            {:deadline, %Group2meet.Deadline{} |> Ecto.Changeset.change() |> to_form()}
        )
      else
        socket
      end

    {:noreply, socket}
  end

  def handle_event("create_deadline", %{"deadline" => params}, socket) do
    {:ok, datetime} = NaiveDateTime.from_iso8601(params["datetime"] <> ":00")
    {:ok, datetime} = DateTime.from_naive(datetime, "America/New_York")

    {:ok, deadline} =
      Group2meet.App.create_deadline(
        %{
          "datetime" => datetime,
          "title" => params["title"]
        },
        socket.assigns.group_id
      )

    socket = assign(socket, in_progress_event: nil)
    {:noreply, socket}
  end

  defp in_progress_event(%{:in_progress_event => {:deadline, form}} = assigns) do
    assigns = assign(assigns, form: form)

    ~H"""
    <.event>
      <p class="mb-4 text-2xl font-bold tracking-tight">New Deadline</p>
      <.form for={@form} phx-submit="create_deadline" class="flex flex-col">
        <.input field={@form[:title]} placeholder="Title" type="text" />
        <.input field={@form[:datetime]} type="datetime-local" />
        <.button class="mx-auto mt-4">Create</.button>
      </.form>
    </.event>
    """
  end

  defp in_progress_event(%{:in_progress_event => nil} = assigns) do
    ~H"""

    """
  end

  defp new_event(assigns) do
    ~H"""
    <.event extra_classes="flex justify-around">
      <button phx-click="new_deadline" class="text-xl tracking-tight">
        Deadline
      </button>
      <button phx-click="new_meeting" class="text-xl tracking-tight">
        Meeting
      </button>
    </.event>
    """
  end

  defp planners(assigns) do
    ~H"""

    """
  end

  defp events(assigns) do
    ~H"""
    <.event :for={deadline <- @deadlines}>
      <div class="flex justify-between items-center font-mono">
        <div class="flex gap-2 items-center">
          <.icon name="hero-exclamation-circle" class="w-6 h-6" />
          <p class="text-lg font-bold"><%= deadline.title %></p>
        </div>
        <div class="flex flex-col items-end gap-2 font-mono">
          <p class="text-lg">
            <%= Calendar.strftime(
              DateTime.shift_zone!(deadline.datetime, "America/New_York"),
              "%a, %B %d"
            ) %>
          </p>
          <p>
            <%= Calendar.strftime(
              DateTime.shift_zone!(deadline.datetime, "America/New_York"),
              "%-I:%M %p"
            ) %>
          </p>
        </div>
      </div>
    </.event>
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
