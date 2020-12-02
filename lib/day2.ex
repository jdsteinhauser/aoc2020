defmodule Day2 do

  def part1 do
    "day2.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.count(&is_valid1?/1)
  end

  def part2 do
    "day2.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.count(&is_valid2?/1)
  end

  def is_valid1?(line) do
    [ll, ul, char, password] = String.split(line, ["-", " ", ":"], trim: true)
    c = char |> to_charlist() |> List.first()
    count = Enum.count(to_charlist(password), &(&1 == c))

    count >= String.to_integer(ll) && count <= String.to_integer(ul)
  end

  def is_valid2?(line) do
    [ll, ul, char, password] = String.split(line, ["-", " ", ":"], trim: true)
    at_ll? = String.at(password, String.to_integer(ll) - 1) == char
    at_ul? = String.at(password, String.to_integer(ul) - 1) == char

    (at_ll? || at_ul?) && !(at_ll? && at_ul?)
  end

end
