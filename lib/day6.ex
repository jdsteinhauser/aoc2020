defmodule Day6 do

  def part1 do
    groups()
    |> Enum.map(&part1_group/1)
    |> Enum.sum()
  end

  def part2 do
    groups()
    |> Enum.map(&part2_group/1)
    |> Enum.sum()
  end

  def part1_group(group) do
    group
    |> Enum.join()
    |> to_charlist()
    |> MapSet.new()
    |> Enum.count()
  end

  def part2_group(group) do
    group
    |> Enum.map(fn ans -> MapSet.new(to_charlist(ans)) end)
    |> Enum.reduce(&MapSet.intersection/2)
    |> Enum.count()
  end

  def groups() do
    "day6.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn group -> String.split(group, "\n", trim: true) end)
  end

end