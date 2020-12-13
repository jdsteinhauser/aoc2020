defmodule Day10 do

  def part1 do
    input() ++ [0, Enum.max(input()) + 3]
    |> Enum.sort()
    |> Enum.chunk_every(2,1, :discard)
    |> Enum.map(fn [x,y] -> y - x end)
    |> Enum.group_by(& &1)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
  end

  def input do
    "day10.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end