defmodule Group2meet.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :contents, :string
    belongs_to :group, Group2meet.Group
    belongs_to :user, Group2meet.User

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:contents])
    |> validate_required([:contents])
  end
end
