defmodule Group2meet.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :name, :string
    has_many :deadlines, Group2meet.Deadline
    has_many :meetings, Group2meet.Meeting
    has_many :messages, Group2meet.Message
    has_many :planners, Group2meet.Planner
    many_to_many :users, Group2meet.User,
      join_through: Group2meet.GroupUser

    timestamps()
  end

  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
