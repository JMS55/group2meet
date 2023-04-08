defmodule Group2meet.GroupUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "group_users" do
    belongs_to :group, Group2meet.Group
    belongs_to :user, Group2meet.User

    timestamps()
  end

  @doc false
  def changeset(group_user, attrs) do
    group_user
    |> cast(attrs, [])
  end
end
