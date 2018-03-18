defmodule Klikker.GamesTest do
  use Klikker.DataCase

  alias Klikker.Games

  describe "spijkerplanken" do
    alias Klikker.Games.Spijkerplank

    @valid_attrs %{name: "Huisje", segments: [[40,38],[38,48],[48,60],[60,62],[62,40],[60,38]]}
    @update_attrs %{}
    @invalid_attrs %{name: "", segments: "abc"}

    def spijkerplank_fixture(attrs \\ %{}) do
      {:ok, spijkerplank} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_spijkerplank()

      spijkerplank
    end

    test "list_spijkerplanken/0 returns all spijkerplanken" do
      spijkerplank = spijkerplank_fixture()
      assert Games.list_spijkerplanken() == [spijkerplank]
    end

    test "get_spijkerplank!/1 returns the spijkerplank with given id" do
      spijkerplank = spijkerplank_fixture()
      assert Games.get_spijkerplank!(spijkerplank.id) == spijkerplank
    end

    test "create_spijkerplank/1 with valid data creates a spijkerplank" do
      assert {:ok, %Spijkerplank{} = spijkerplank} = Games.create_spijkerplank(@valid_attrs)
      assert spijkerplank.name == "Huisje"
      assert spijkerplank.segments == [[40,38],[38,48],[48,60],[60,62],[62,40],[60,38]]
    end

    test "create_spijkerplank/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_spijkerplank(@invalid_attrs)
    end

    test "update_spijkerplank/2 with valid data updates the spijkerplank" do
      spijkerplank = spijkerplank_fixture()
      assert {:ok, spijkerplank} = Games.update_spijkerplank(spijkerplank, @update_attrs)
      assert %Spijkerplank{} = spijkerplank
    end

    test "update_spijkerplank/2 with invalid data returns error changeset" do
      spijkerplank = spijkerplank_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_spijkerplank(spijkerplank, @invalid_attrs)
      assert spijkerplank == Games.get_spijkerplank!(spijkerplank.id)
    end

    test "delete_spijkerplank/1 deletes the spijkerplank" do
      spijkerplank = spijkerplank_fixture()
      assert {:ok, %Spijkerplank{}} = Games.delete_spijkerplank(spijkerplank)
      assert_raise Ecto.NoResultsError, fn -> Games.get_spijkerplank!(spijkerplank.id) end
    end

    test "change_spijkerplank/1 returns a spijkerplank changeset" do
      spijkerplank = spijkerplank_fixture()
      assert %Ecto.Changeset{} = Games.change_spijkerplank(spijkerplank)
    end
  end

  describe "ideas" do
    alias Klikker.Games.Idea

    @valid_attrs %{body: "some body", name: "some name"}
    @update_attrs %{body: "some updated body", name: "some updated name"}
    @invalid_attrs %{body: nil, name: nil}

    def idea_fixture(attrs \\ %{}) do
      {:ok, idea} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_idea()

      idea
    end

    test "list_ideas/0 returns all ideas" do
      idea = idea_fixture()
      assert Games.list_ideas() == [idea]
    end

    test "get_idea!/1 returns the idea with given id" do
      idea = idea_fixture()
      assert Games.get_idea!(idea.id) == idea
    end

    test "create_idea/1 with valid data creates a idea" do
      assert {:ok, %Idea{} = idea} = Games.create_idea(@valid_attrs)
      assert idea.body == "some body"
      assert idea.name == "some name"
    end

    test "create_idea/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_idea(@invalid_attrs)
    end

    test "update_idea/2 with valid data updates the idea" do
      idea = idea_fixture()
      assert {:ok, idea} = Games.update_idea(idea, @update_attrs)
      assert %Idea{} = idea
      assert idea.body == "some updated body"
      assert idea.name == "some updated name"
    end

    test "update_idea/2 with invalid data returns error changeset" do
      idea = idea_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_idea(idea, @invalid_attrs)
      assert idea == Games.get_idea!(idea.id)
    end

    test "delete_idea/1 deletes the idea" do
      idea = idea_fixture()
      assert {:ok, %Idea{}} = Games.delete_idea(idea)
      assert_raise Ecto.NoResultsError, fn -> Games.get_idea!(idea.id) end
    end

    test "change_idea/1 returns a idea changeset" do
      idea = idea_fixture()
      assert %Ecto.Changeset{} = Games.change_idea(idea)
    end
  end
end
