defmodule Day4 do
  def part1 do
    "day4.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(&make_pairs/1)
    |> Enum.count(&is_valid1?/1)
  end

  def part2 do
    "day4.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(&make_pairs/1)
    |> Enum.count(&is_valid2?/1)
  end

  def make_pairs(line) do
    line
    |> String.split( ~r/\s+/, trim: true)
    |> Enum.map(fn x -> String.split(x, ":", trim: true) end)
    |> Map.new(fn [k,v | _] -> {String.to_atom(k), v} end)
  end

  def is_valid1?(%{byr: _, iyr: _, eyr: _, hgt: _, hcl: _, ecl: _, pid: _}), do: true
  def is_valid1?(%{}), do: false

  def is_valid2?(%{byr: byr, iyr: iyr, eyr: eyr, hgt: hgt, hcl: hcl, ecl: ecl, pid: pid}) do
    ecls = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

    with {byr_, _} <- Integer.parse(byr),
         true <- byr_ >= 1920 and byr_ <= 2002 and String.length(byr) == 4,
         {iyr_, _} <- Integer.parse(iyr),
         true <- iyr_ >= 2010 and iyr_ <= 2020 and String.length(iyr) == 4,
         {eyr_, _} <- Integer.parse(eyr),
         true <- eyr_ >= 2020 and eyr_ <= 2030 and String.length(eyr) == 4,
         {hgt_, units} <- Integer.parse(hgt),
         true <- units == "cm" or units == "in",
         true <- (if units == "cm", do: hgt_ >= 150 and hgt_ <= 193, else: hgt_ >= 59 and hgt_ <= 76),
         true <- String.length(hcl) == 7,
         {hcl_str, true} <- { String.slice(hcl, 1..6), String.starts_with?(hcl, "#") },
         {_, _} <- Integer.parse(hcl_str, 16),
         true <- ecl in ecls,
         {_, _} <- Integer.parse(pid),
         true <- String.length(pid) == 9
    do
      true
    else
      _ -> false
    end
  end

  def is_valid2?(%{}), do: false

end
