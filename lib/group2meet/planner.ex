defmodule Group2meet.Planner do
  use Ecto.Schema
  import Ecto.Changeset

  schema "planners" do
    field :end_date, :date
    field :end_time, :time
    field :start_date, :date
    field :start_time, :time
    field :title, :string
    belongs_to :group, Group2meet.Group
    has_many :planner_responses, Group2meet.PlannerResponse

    timestamps()
  end

  @doc false
  def changeset(planner, attrs) do
    planner
    |> cast(attrs, [:title, :start_date, :end_date, :start_time, :end_time])
    |> validate_required([:title, :start_date, :end_date, :start_time, :end_time])
  end
end
