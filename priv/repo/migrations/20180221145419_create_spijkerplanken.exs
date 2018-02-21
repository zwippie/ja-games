defmodule Klikker.Repo.Migrations.CreateSpijkerplanken do
  use Ecto.Migration

  def change do
    create table(:spijkerplanken) do
      add :name, :string, null: false
      add :segments, {:array, {:array, :integer}}, null: false

      timestamps()
    end

  end
end
