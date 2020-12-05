defmodule Day5 do

  def part1 do 
    data()
    |> Enum.map(&seat_id/1)
    |> Enum.max()
  end

  def part2 do
    data()
    |> Enum.map(&seat_id/1)
    |> Enum.sort()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.find(fn [x, y] -> y - x == 2 end)
    |> hd()
    |> Kernel.+(1)
  end

  def seat_id(value), do: seat_id(value, 0.0, 127.0, 0.0, 7.0)

  def seat_id("", row, row, col, col), do: trunc(row * 8 + col)

  def seat_id("F" <> rest, front, back, left, right) do
    seat_id(rest, front, front + (back - front + 1) / 2 - 1, left, right)
  end
  
  def seat_id("B" <> rest, front, back, left, right) do
    seat_id(rest, front + (back - front + 1) / 2, back, left, right)
  end

  def seat_id("L" <> rest, front, back, left, right) do
    seat_id(rest, front, back, left, left + (right - left  + 1) / 2 - 1)
  end

  def seat_id("R" <> rest, front, back, left, right) do
    seat_id(rest, front, back, left + (right - left + 1) / 2, right)
  end

  def data do
    "day5.txt"
    |> File.stream!()
    |> Enum.map(&String.trim/1)
  end
end