defmodule Group2meet.Meeting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meetings" do
    field :title, :string
    field :date, :date
    field :end_time, :time
    field :start_time, :time
    belongs_to :group, Group2meet.Group

    timestamps()
  end

  @doc false
  def changeset(meeting, attrs) do
    meeting
    |> cast(attrs, [:title, :date, :start_time, :end_time])
    |> validate_required([:title, :date, :start_time, :end_time])
  end
end
