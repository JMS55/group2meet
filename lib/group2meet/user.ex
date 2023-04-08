defmodule Group2meet.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :auth_id, :string
    field :name, :string
    has_many :planner_responses, Group2meet.PlannerResponse
    has_many :messages, Group2meet.Message
    many_to_many :groups, Group2meet.Group,
      join_through: Group2meet.GroupUser

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:auth_id, :name])
    |> validate_required([:auth_id, :name])
  end
end
