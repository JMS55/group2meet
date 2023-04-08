defmodule Group2meet.Meeting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meetings" do
    field :end_datetime, :utc_datetime
    field :start_datetime, :utc_datetime
    field :title, :string
    belongs_to :group, Group2meet.Group

    timestamps()
  end

  @doc false
  def changeset(meeting, attrs) do
    meeting
    |> cast(attrs, [:title, :start_datetime, :end_datetime])
    |> validate_required([:title, :start_datetime, :end_datetime])
  end
end
