defmodule Group2meet.Repo.Migrations.Initial do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :auth_id, :string
      add :name, :string

      timestamps()
    end

    create table(:groups) do
      add :name, :string

      timestamps()
    end

    create table(:group_users) do
      add :group_id, references(:groups)
      add :user_id, references(:users)

      timestamps()
    end

    create table(:messages) do
      add :group_id, references(:groups)
      add :user_id, references(:users)
      add :contents, :string

      timestamps()
    end

    create table(:deadlines) do
      add :group_id, references(:groups)
      add :title, :string
      add :datetime, :utc_datetime

      timestamps()
    end

    create table(:meetings) do
      add :group_id, references(:groups)
      add :title, :string
      add :start_datetime, :utc_datetime
      add :end_datetime, :utc_datetime

      timestamps()
    end

    create table(:planners) do
      add :group_id, references(:groups)
      add :title, :string
      add :start_date, :date
      add :end_date, :date
      add :start_time, :time
      add :end_time, :time

      timestamps()
    end

    create table(:planner_responses) do
      add :user_id, references(:users)
      add :planner_id, references(:planners)
      add :available_cells, {:array, :integer}

      timestamps()
    end
  end
end
