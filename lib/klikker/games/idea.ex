defmodule Klikker.Games.Idea do
  use Ecto.Schema
  import Ecto.Changeset
  alias Klikker.Games.Idea


  schema "ideas" do
    field :body, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Idea{} = idea, attrs) do
    idea
    |> cast(attrs, [:name, :body])
    |> validate_required([:name, :body])
  end
end
