defmodule Klikker.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias Klikker.Repo

  alias Klikker.Games.Spijkerplank

  @doc """
  Returns the list of spijkerplanken.

  ## Examples

      iex> list_spijkerplanken()
      [%Spijkerplank{}, ...]

  """
  def list_spijkerplanken do
    Repo.all(Spijkerplank)
  end

  @doc """
  Gets a single spijkerplank.

  Raises `Ecto.NoResultsError` if the Spijkerplank does not exist.

  ## Examples

      iex> get_spijkerplank!(123)
      %Spijkerplank{}

      iex> get_spijkerplank!(456)
      ** (Ecto.NoResultsError)

  """
  def get_spijkerplank!(id), do: Repo.get!(Spijkerplank, id)

  @doc """
  Creates a spijkerplank.

  ## Examples

      iex> create_spijkerplank(%{field: value})
      {:ok, %Spijkerplank{}}

      iex> create_spijkerplank(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_spijkerplank(attrs \\ %{}) do
    %Spijkerplank{}
    |> Spijkerplank.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a spijkerplank.

  ## Examples

      iex> update_spijkerplank(spijkerplank, %{field: new_value})
      {:ok, %Spijkerplank{}}

      iex> update_spijkerplank(spijkerplank, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_spijkerplank(%Spijkerplank{} = spijkerplank, attrs) do
    spijkerplank
    |> Spijkerplank.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Spijkerplank.

  ## Examples

      iex> delete_spijkerplank(spijkerplank)
      {:ok, %Spijkerplank{}}

      iex> delete_spijkerplank(spijkerplank)
      {:error, %Ecto.Changeset{}}

  """
  def delete_spijkerplank(%Spijkerplank{} = spijkerplank) do
    Repo.delete(spijkerplank)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking spijkerplank changes.

  ## Examples

      iex> change_spijkerplank(spijkerplank)
      %Ecto.Changeset{source: %Spijkerplank{}}

  """
  def change_spijkerplank(%Spijkerplank{} = spijkerplank) do
    Spijkerplank.changeset(spijkerplank, %{})
  end

  alias Klikker.Games.Idea

  @doc """
  Returns the list of ideas.

  ## Examples

      iex> list_ideas()
      [%Idea{}, ...]

  """
  def list_ideas do
    Repo.all(Idea)
  end

  @doc """
  Gets a single idea.

  Raises `Ecto.NoResultsError` if the Idea does not exist.

  ## Examples

      iex> get_idea!(123)
      %Idea{}

      iex> get_idea!(456)
      ** (Ecto.NoResultsError)

  """
  def get_idea!(id), do: Repo.get!(Idea, id)

  @doc """
  Creates a idea.

  ## Examples

      iex> create_idea(%{field: value})
      {:ok, %Idea{}}

      iex> create_idea(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_idea(attrs \\ %{}) do
    %Idea{}
    |> Idea.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a idea.

  ## Examples

      iex> update_idea(idea, %{field: new_value})
      {:ok, %Idea{}}

      iex> update_idea(idea, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_idea(%Idea{} = idea, attrs) do
    idea
    |> Idea.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Idea.

  ## Examples

      iex> delete_idea(idea)
      {:ok, %Idea{}}

      iex> delete_idea(idea)
      {:error, %Ecto.Changeset{}}

  """
  def delete_idea(%Idea{} = idea) do
    Repo.delete(idea)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking idea changes.

  ## Examples

      iex> change_idea(idea)
      %Ecto.Changeset{source: %Idea{}}

  """
  def change_idea(%Idea{} = idea) do
    Idea.changeset(idea, %{})
  end
end
