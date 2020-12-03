defmodule Day3 do
  def part1, do: slope(3, 1)

  def part2 do
    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(fn {right, down} -> slope(right, down) end)
    |> Enum.reduce(&*/2)


  end

  defp grid do
    "day3.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, i} -> Enum.map(Enum.with_index(to_charlist(row)), fn {x, j} -> {{i, j}, x == ?#} end) end)
      |> Map.new()
  end

  def slope(right, down) do
    with grid <- grid(),
         {{nrows, _} , _} <- Enum.max_by(grid, fn {{x,_}, _} -> x end),
         {{_, ncols} , _} <- Enum.max_by(grid, fn {{_,y}, _} -> y end),
         rows <- Enum.filter(0..nrows, &(rem(&1, down) == 0)),
         cols <- Stream.iterate(0, &(rem(&1 + right, ncols + 1))),
         pairs <- Enum.zip(rows, cols)
    do
      Enum.count(pairs, fn x -> grid[x] end)
    end
  end
end
