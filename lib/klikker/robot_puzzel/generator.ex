defmodule Klikker.RobotPuzzel.Generator do
  @moduledoc false

  @no_rows 5
  @no_cols 5
  @no_cells @no_rows * @no_cols
  @base_idx div(@no_rows * @no_cols - 1, 2)

  @colors ~w(green blue yellow purple orange)

  @max_moves 10
  @min_moves 4

  @doc """
  Generate a new lunar lander puzzle.
  """
  def generate do
    generate_puzzel()
    |> assign_colors()
    |> Enum.into([], fn {c, i} -> %{color: c, index: i} end)
  end

  defp assign_colors({_, position, red_index, _}) do
    @colors
    |> List.insert_at(red_index, "red")
    |> Enum.zip(position)
  end

  defp generate_puzzel do
    solve(place_robots(), @base_idx)
    |> List.wrap()
    |> Enum.filter(fn result -> elem(result, 0) == :has_solution end)
    |> case do
      [] ->
        # No solution found for this start position, try again
        generate_puzzel()

      positions ->
        case find_best_position(positions) do
          # Start position is solved too easily, try again
          {_, _, _, moves} when moves < @min_moves ->
            generate_puzzel()

          # This is a valid start position
          position ->
            position
        end
    end
  end

  # Return the indexes where robots are placed
  defp place_robots do
    Enum.take_random(0..(@no_cells - 1), 2 + :rand.uniform(4))
  end

  # Find start position for red where it has the greatest minimal no_moves
  defp find_best_position(positions) do
    positions
    |> Enum.sort_by(fn {_, _, _, no_moves} -> no_moves end)
    |> Enum.group_by(fn {_, _, red_index, _} -> red_index end)
    |> Map.values()
    |> Enum.map(&hd/1)
    |> Enum.sort_by(fn {_, _, _, no_moves} -> no_moves end)
    |> List.last()
  end

  # Try to solve the puzzle when starting with robots (list of indices)
  defp solve(robots, base_idx) do
    solve(robots, base_idx, robots, 1)
  end

  defp solve(_, _, start_robots, @max_moves), do: {:max_depth_reached, start_robots}

  defp solve(robots, base_idx, start_robots, depth) do
    # For comparison purposes
    empty_result = List.duplicate([], length(robots))

    robots
    |> Enum.map(&find_target_spots(robots, &1))
    |> Enum.map(fn spots -> Enum.reject(spots, &(&1 in robots)) end)
    |> case do
      ^empty_result ->
        {:no_solution, start_robots}

      spots ->
        # is there a move that ends the game?
        is_end = List.flatten(spots) |> Enum.member?(base_idx)

        cond do
          is_end ->
            red_index = Enum.find_index(spots, &Enum.member?(&1, base_idx))
            {:has_solution, start_robots, red_index, depth}

          true ->
            # Try all moves
            perform_moves(robots, spots)
            |> Enum.map(&solve(&1, base_idx, start_robots, depth + 1))
            |> List.flatten()
        end
    end
  end

  defp perform_moves(robots, spots) do
    spots
    |> Enum.with_index()
    |> Enum.flat_map(fn {spots2, idx} ->
      spots2
      |> Enum.map(fn spot ->
        List.replace_at(robots, idx, spot)
      end)
    end)
  end

  defp find_target_spots(robots, from_idx) do
    look_left(robots, from_idx) ++
      look_right(robots, from_idx) ++ look_up(robots, from_idx) ++ look_down(robots, from_idx)
  end

  defp look_left(robots, from_idx) do
    from_col = rem(from_idx, @no_cols)

    cond do
      from_col - 1 < 0 ->
        []

      (from_idx - 1) in robots ->
        [from_idx]

      true ->
        look_left(robots, from_idx - 1)
    end
  end

  defp look_right(robots, from_idx) do
    from_col = rem(from_idx, @no_cols)

    cond do
      from_col + 1 >= @no_cols ->
        []

      (from_idx + 1) in robots ->
        [from_idx]

      true ->
        look_right(robots, from_idx + 1)
    end
  end

  defp look_up(robots, from_idx) do
    from_row = div(from_idx, @no_cols)

    cond do
      from_row - 1 < 0 ->
        []

      (from_idx - @no_cols) in robots ->
        [from_idx]

      true ->
        look_up(robots, from_idx - @no_cols)
    end
  end

  defp look_down(robots, from_idx) do
    from_row = div(from_idx, @no_cols)

    cond do
      from_row + 1 >= @no_rows ->
        []

      (from_idx + @no_cols) in robots ->
        [from_idx]

      true ->
        look_down(robots, from_idx + @no_cols)
    end
  end
end
