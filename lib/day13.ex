defmodule Day13 do

  @start 100_000_000_000_000

  def part1 do
    %{trains: trains, time: time} = input()
    trains
    |> Enum.reject(& &1 == 0)
    |> Enum.map(& {&1, &1 - rem(time, &1)})
    |> Enum.min_by(& elem(&1, 1))
    |> (fn {x,y} -> x * y end).()
  end

  def part2 do
    %{trains: trains} = input()
    with_idx =
      trains
      |> Enum.with_index(1)
      |> Enum.reject(fn {x,_} -> x == 0 end)
    inc = elem(hd(with_idx),1)
    start = inc - rem(@start, inc) + @start
    Stream.iterate(start, & &1 + inc)
    |> Stream.drop_while(fn value -> !Enum.all?(with_idx, fn {x, y} -> x - rem(value, x) == y end) end)
    |> Stream.take(1)
    |> Enum.to_list()
  end

  def input do
    [time_str, trains_str] =
      "day13.txt" 
      |> File.read!()
      |> String.split("\n", trim: true)

    trains =
      trains_str
      |> String.split(",", trim: true)
      |> Enum.map(fn x -> if Integer.parse(x) == :error, do: 0, else: String.to_integer(x) end)

    %{time: String.to_integer(time_str), trains: trains}
  end
end