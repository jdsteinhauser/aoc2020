defmodule Day1 do

  def part1 do
    data =
      File.read!("day1.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    {one, two} =
      for x <- data, y <- data do
        {x,y}
      end
      |> Enum.find(fn {x,y} -> x + y == 2020 end)

    one * two
  end

  def part2 do
    data =
      File.read!("day1.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    {one, two, tre} =
      for x <- data, y <- data, z <- data do
        {x,y,z}
      end
      |> Enum.find(fn {x,y,z} -> x + y + z == 2020 end)

    one * two * tre
  end
end
