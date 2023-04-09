defmodule Group2meet.Deadline do
  use Ecto.Schema
  import Ecto.Changeset

  schema "deadlines" do
    field :title, :string
    field :datetime, :utc_datetime
    belongs_to :group, Group2meet.Group

    timestamps()
  end

  @doc false
  def changeset(deadline, attrs) do
    deadline
    |> cast(attrs, [:title, :datetime])
    |> validate_required([:title, :datetime])
  end
end
