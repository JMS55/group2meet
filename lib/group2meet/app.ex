defmodule Group2meet.App do
  alias Group2meet.{Deadline, Group, GroupUser, Meeting, Message, PlannerResponse, Planner, User}
  alias Group2meet.Repo
  alias Ecto.Changeset

  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def create_group(params) do
    %Group{}
    |> Group.changeset(params)
    |> Repo.insert()
  end

  def add_user_to_group(user_id, group_id) do
    group = Repo.get(Group, group_id)
    user = Repo.get(User, user_id)

    %GroupUser{}
    |> GroupUser.changeset(%{})
    |> Changeset.put_assoc(:group, group)
    |> Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def list_messages(group_id) do
    group = Group
    |> Repo.get(group_id)
    |> Repo.preload(messages: :user)

    group.messages
  end

  def post_message(params, group_id, user_id) do
    group = Repo.get(Group, group_id)
    user = Repo.get(User, user_id)

    %Message{}
    |> Message.changeset(params)
    |> Changeset.put_assoc(:group, group)
    |> Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end
end
