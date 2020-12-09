defmodule Day9 do

  def part1 do
    data()
    |> Enum.chunk_every(26, 1, :discard)
    |> Enum.find(fn chunk -> !is_sum?(Enum.split(chunk, 25)) end)
    |> List.last()
  end

  def part2 do
    value = part1()

    subset = Enum.take_while(data(), fn x -> x != value end)
    for x <- 0..length(subset) - 1, y <- x..length(subset) - 1
    do
      Enum.slice(subset, x..y)
    end
    |> Enum.find(fn xs -> Enum.reduce(xs, &Kernel.+/2) == value end)
    |> Enum.min_max()
    |> (fn {x,y} -> x + y end).()
  end

  def is_sum?({set, [value]}) do
    for x <- set, y <- set
    do
      x + y
    end
    |> Enum.any?(fn x -> x == value end)
  end

  def data do
    "day9.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end
end
