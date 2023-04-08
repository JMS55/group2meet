defmodule Group2meet.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :contents, :string
    field :sequence_number, :integer
    field :timestamp, :utc_datetime
    belongs_to :group, Group2meet.Group
    belongs_to :user, Group2meet.User

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:sequence_number, :contents, :timestamp])
    |> validate_required([:sequence_number, :contents, :timestamp])
  end
end
