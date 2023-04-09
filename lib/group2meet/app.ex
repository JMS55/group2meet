defmodule Group2meet.App do
  alias Group2meet.{Deadline, Group, GroupUser, Meeting, Message, Planner, PlannerResponse, User}
  alias Group2meet.Repo
  alias Ecto.Changeset

  def create_deadline(params, group_id) do
    group = Repo.get(Group, group_id)

    %Deadline{}
    |> Deadline.changeset(params)
    |> Changeset.put_assoc(:group, group)
    |> Repo.insert()
  end

  def get_deadlines(group_id) do
    group = Group
    |> Repo.get(group_id)
    |> Repo.preload(:deadlines)

    group.deadlines
  end

  def create_group(params) do
    %Group{}
    |> Group.changeset(params)
    |> Repo.insert()
  end
  
  def get_group(group_id) do
    Group |> Repo.get(group_id)
  end

  def get_groups(user_id) do
    user = User
    |> Repo.get(user_id)
    |> Repo.preload(:groups)

    user.groups
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

  def create_meeting(params, group_id) do
    group = Repo.get(Group, group_id)

    %Meeting{}
    |> Meeting.changeset(params)
    |> Changeset.put_assoc(:group, group)
    |> Repo.insert()
  end

  def get_meetings(group_id) do
    group = Group
    |> Repo.get(group_id)
    |> Repo.preload(:meetings)

    group.meetings
  end

  def get_events(group_id) do
    Enum.concat(
      Enum.map(get_deadlines(group_id), &{:deadline, &1}),
      Enum.map(get_meetings(group_id), &{:meeting, &1})
    )
    |> Enum.sort_by(fn
      {:deadline, deadline} -> deadline.datetime
      {:meeting, meeting} -> DateTime.new!(meeting.date, meeting.start_time)
    end)
  end

  def create_message(params, group_id, user_id) do
    group = Repo.get(Group, group_id)
    user = Repo.get(User, user_id)

    %Message{}
    |> Message.changeset(params)
    |> Changeset.put_assoc(:group, group)
    |> Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def get_messages(group_id) do
    group = Group
    |> Repo.get(group_id)
    |> Repo.preload(messages: :user)

    group.messages
  end

  def create_planner(params, group_id) do
    group = Repo.get(Group, group_id)

    %Planner{}
    |> Planner.changeset(params)
    |> Changeset.put_assoc(:group, group)
    |> Repo.insert()
  end

  def get_planners(group_id) do
    group = Group
    |> Repo.get(group_id)
    |> Repo.preload(:planners)

    group.planners
  end

  def create_user(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end

  def get_users(group_id) do
    group = Group
    |> Repo.get(group_id)
    |> Repo.preload(:users)

    group.users
  end

  def update_planner_response(params, user_id, planner_id) do
    user = Repo.get(User, user_id)
    planner = Repo.get(Planner, planner_id)

    %PlannerResponse{}
    |> PlannerResponse.changeset(params)
    |> Changeset.put_assoc(:user, user)
    |> Changeset.put_assoc(:planner, planner)
    |> Repo.insert(
      conflict_target: [:user_id, :planner_id],
      on_conflict: {:replace, [:available_cells]}
    )
  end

  def get_planner_responses(planner_id) do
    planner = Planner
    |> Repo.get(planner_id)
    |> Repo.preload(:planner_responses)

    planner.planner_responses
  end
end
