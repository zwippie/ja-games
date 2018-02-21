defmodule Klikker.Games.Spijkerplank do
  use Ecto.Schema
  import Ecto.Changeset
  alias Klikker.Games.Spijkerplank


  schema "spijkerplanken" do
    field :name, :string
    field :segments, {:array, {:array, :integer}}

    timestamps()
  end

  @doc false
  def changeset(%Spijkerplank{} = spijkerplank, attrs) do
    spijkerplank
    |> cast(attrs, [:name, :segments])
    |> validate_required([:name, :segments])
  end
end
