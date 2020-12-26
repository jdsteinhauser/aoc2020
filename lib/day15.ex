defmodule Day15 do

  def part1 do
    %{starters: input(), turn: 1, last: nil, history: %{}}
    |> Stream.iterate(&next/1)
    |> Stream.drop(2020)
    |> Enum.at(0)
  end

  def part2 do
    %{starters: input(), turn: 1, last: nil, history: %{}}
    |> Stream.iterate(&next/1)
    |> Stream.drop(30_000_000)
    |> Enum.at(0)
  end

  def next(%{starters: [], turn: turn, last: last, history: history}) do
    speak = case Map.get(history, last) do
      nil -> 0
      x -> turn - 1 - x
    end

    %{starters: [], turn: turn + 1, last: speak, history: Map.put(history, last, turn - 1)}
  end

  def next(%{starters: [x | rest], turn: turn, last: nil, history: %{}}), do: %{starters: rest, turn: turn + 1, last: x, history: %{}}

  def next(%{starters: [x | rest], turn: turn, last: last, history: history}) do
    new_history = Map.put(history, last, turn - 1)
    %{starters: rest, turn: turn + 1, last: x, history: new_history}
  end

  def input, do: [20,0,1,11,6,3]

end