defmodule Klikker.Repo.Migrations.CreateIdeas do
  use Ecto.Migration

  def change do
    create table(:ideas) do
      add :name, :string
      add :body, :string

      timestamps()
    end

  end
end
