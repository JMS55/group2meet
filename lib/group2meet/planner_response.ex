defmodule Group2meet.PlannerResponses do
  use Ecto.Schema
  import Ecto.Changeset

  schema "planner_responses" do
    field :available_cells, {:array, :integer}
    belongs_to :user, Group2meet.User
    belongs_to :planner, Group2meet.Planner

    timestamps()
  end

  @doc false
  def changeset(planner_response, attrs) do
    planner_response
    |> cast(attrs, [:available_cells])
    |> validate_required([:available_cells])
  end
end
