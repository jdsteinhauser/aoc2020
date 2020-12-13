defmodule Day7 do

  def part1 do
    data()
    |> part1_reducer(["shiny gold"], MapSet.new())
    |> Enum.count()
  end

  def part2, do: part2_reducer(data(), "shiny gold") - 1

  def data do
    "day7.txt"
    |> File.stream!()
    |> Enum.map(&split_line/1)
    |> Map.new()
  end

  def split_line(line) do
    [parent | children_str] = String.split(line, [" bags contain ", ".", ", "], trim: true)

    children =
      children_str
      |> Enum.map(fn x -> String.split(x, " ") end)
      |> Enum.filter(fn xs -> length(xs) == 4 end)
      |> Enum.map(fn [n, adj, color, _] -> {"#{adj} #{color}", String.to_integer(n) } end)
      |> Map.new()

    {parent, children}
  end

  def part1_reducer(_, [], set), do: set

  def part1_reducer(map, lookups, set) do
    keys =
      map
      |> Enum.filter(fn {_k, vs} -> Enum.any?(vs, fn {k2, _} -> k2 in lookups end) end)
      |> Enum.map(& elem(&1, 0))
    part1_reducer(map, keys, MapSet.union(set, MapSet.new(keys)))
  end

  def part2_reducer(_map, ""), do: 1

  def part2_reducer(map, key) do
    map
    |> Map.get(key)
    |> Enum.map(fn {k, v} -> v * part2_reducer(map, k) end)
    |> Enum.sum()
    |> Kernel.+(1)
  end

end