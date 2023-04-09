alias Group2meetWeb.CoreComponents
import CoreComponents

defmodule EventsPane do
  use Phoenix.LiveView, container: {:div, class: "contents"}

  def render(assigns) do
    ~H"""
    <div class="p-4 rounded-lg bg-white shadow-lg flex flex-col gap-4 overflow-y-auto">
      <.in_progress_event :if={@in_progress_event != nil} in_progress_event={@in_progress_event} />
      <.planner :for={planner <- @planners} planner={planner} user_id={@user_id} />
      <.new_event />
      <.events events={@events} />
    </div>
    """
  end

  def mount(_params, session, socket) do
    group_id = session["group_id"]
    user_id = session["user_id"]

    socket = assign(socket, user_id: user_id)
    socket = assign(socket, group_id: group_id)
    socket = assign(socket, in_progress_event: nil)
    socket = assign(socket, events: Group2meet.App.get_events(group_id))
    socket = assign(socket, planners: Group2meet.App.get_planners(group_id, user_id))

    {:ok, socket}
  end

  def handle_event("new_deadline", _, socket) do
    socket =
      assign(socket,
        in_progress_event:
          {:deadline, %Group2meet.Deadline{} |> Ecto.Changeset.change() |> to_form()}
      )

    {:noreply, socket}
  end

  def handle_event("new_meeting", _, socket) do
    socket =
      assign(socket,
        in_progress_event:
          {:meeting, %Group2meet.Meeting{} |> Ecto.Changeset.change() |> to_form()}
      )

    {:noreply, socket}
  end

  def handle_event("create_deadline", %{"deadline" => params}, socket) do
    {:ok, datetime} = NaiveDateTime.from_iso8601(params["datetime"] <> ":00")
    {:ok, datetime} = DateTime.from_naive(datetime, "America/New_York")

    {:ok, _deadline} =
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

  def handle_event("create_meeting", %{"meeting" => params}, socket) do
    {:ok, date} = Date.from_iso8601(params["date"])
    {:ok, start_time} = Time.from_iso8601(params["start_time"] <> ":00")
    {:ok, end_time} = Time.from_iso8601(params["end_time"] <> ":00")

    {:ok, _meeting} =
      Group2meet.App.create_meeting(
        %{
          "title" => params["title"],
          "date" => date,
          "start_time" => start_time,
          "end_time" => end_time
        },
        socket.assigns.group_id
      )

    socket = assign(socket, in_progress_event: nil)
    {:noreply, socket}
  end

  def handle_event("toggle_cell", %{"planner_id" => planner_id, "index" => index}, socket) do
    Group2meet.App.toggle_planner_response_cell(index, socket.assigns.user_id, planner_id)
    socket = assign(socket, planners: Group2meet.App.get_planners(socket.assigns.group_id, socket.assigns.user_id))
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

  defp in_progress_event(%{:in_progress_event => {:meeting, form}} = assigns) do
    assigns = assign(assigns, form: form)

    ~H"""
    <.event extra_classes="flex flex-col">
      <p class="mb-4 text-2xl font-bold tracking-tight">New Meeting</p>
      <.form for={@form} phx-submit="create_meeting" class="flex flex-col gap-2">
        <.input field={@form[:title]} placeholder="Title" type="text" />
        <.input field={@form[:date]} type="date" />
        <div class="flex">
          <div class="flex items-center gap-2">
            <.label for="start">Start</.label>
            <.input field={@form[:start_time]} id="start" type="time" />
          </div>
          <div class="flex items-center gap-2 ml-4">
            <.label for="end">End</.label>
            <.input field={@form[:end_time]} id="end" type="time" />
          </div>
        </div>
        <.button class="mx-auto mt-4">Create</.button>
      </.form>
    </.event>
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

  defp planner(assigns) do
    planner = assigns.planner
    num_rows = Time.diff(planner.end_time, planner.start_time, :hour) * 4
    num_cols = Date.diff(planner.end_date, planner.start_date) + 1
    user_response = Enum.find(planner.planner_responses, &(&1.user_id == assigns.user_id))
    assigns = assign(assigns, num_rows: num_rows)
    assigns = assign(assigns, rows: Enum.to_list(0..(num_rows - 1)))
    assigns = assign(assigns, cols: Enum.to_list(0..(num_cols - 1)))

    cell_color = fn (i, j) -> if Enum.any?(user_response.available_cells, &(&1 == i + j * num_rows)), do: "bg-green-500", else: "bg-red-500" end
    assigns = assign(assigns, cell_color: cell_color)

    ~H"""
    <.event>
      <table>
        <tbody>
          <%= for i <- @rows do %>
            <tr>
              <%= for j <- @cols do %>
                <td phx-click="toggle_cell" phx-value-planner_id={@planner.id} phx-value-index={i + j * @num_rows} class={"w-12 h-3 border-[1px] border-slate-800 #{@cell_color.(i, j)}"} />
              <% end %>
            </tr>
          <% end %>
        </tbody>
      </table>
    </.event>
    """
  end

  defp events(assigns) do
    ~H"""
    <%= for {type, event} <- @events do %>
      <.deadline_event :if={type == :deadline} deadline={event} />
      <.meeting_event :if={type == :meeting} meeting={event} />
    <% end %>
    """
  end

  defp deadline_event(assigns) do
    ~H"""
    <.event extra_classes="flex justify-between items-center font-mono">
      <div class="flex gap-2 items-center">
        <.icon name="hero-exclamation-circle" class="w-6 h-6" />
        <p class="text-xl font-bold"><%= @deadline.title %></p>
      </div>
      <div class="flex flex-col items-end gap-2 font-mono">
        <p class="text-lg">
          <%= Calendar.strftime(
            DateTime.shift_zone!(@deadline.datetime, "America/New_York"),
            "%a, %B %d"
          ) %>
        </p>
        <p>
          <%= Calendar.strftime(
            DateTime.shift_zone!(@deadline.datetime, "America/New_York"),
            "%-I:%M %p"
          ) %>
        </p>
      </div>
    </.event>
    """
  end

  defp meeting_event(assigns) do
    ~H"""
    <.event extra_classes="flex justify-between items-center font-mono">
      <div class="flex gap-2 items-center">
        <.icon name="hero-flag" class="w-6 h-6" />
        <p class="text-xl font-bold"><%= @meeting.title %></p>
      </div>
      <div class="flex flex-col items-end gap-2 font-mono">
        <p class="text-lg">
          <%= Calendar.strftime(@meeting.date, "%a, %B %d") %>
        </p>
        <p>
          <%= Calendar.strftime(@meeting.start_time, "%-I:%M %p") %> - <%= Calendar.strftime(
            @meeting.end_time,
            "%-I:%M %p"
          ) %>
        </p>
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
