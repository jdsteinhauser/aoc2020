defmodule Day14 do

  def part1 do
    input()
    |> Enum.reduce(%{memory: %{}}, fn cmd, system -> execute(system, cmd) end)
    |> Map.get(:memory)
    |> Map.values()
    |> Enum.sum()
  end

  def input do
    "day14.txt"
    |> File.stream!()
    |> Enum.map(&format_line/1)
  end

  def format_line("mask = " <> mask), do: %{cmd: :mask, value: String.trim(mask)}
  
  def format_line("mem[" <> rest) do
    tokens = String.split(rest, ["] = ", "\n"], trim: true)
    %{cmd: :set,
      addr: String.to_integer(List.first(tokens)),
      value: String.to_integer(List.last(tokens))
    }
  end

  def execute(system, %{cmd: :mask, value: value}), do: Map.put(system, :mask, to_charlist(value))

  def execute(system, %{cmd: :set, addr: addr, value: value}) do
    new_value = mask(value, system)
    put_in(system, [:memory, addr], new_value)
  end
  
  def mask(value, %{mask: mask}) do
    digits = Integer.digits(value, 2)
    len = length(digits)
    to_mask = List.duplicate(0, 36 - len) ++ digits

    mask
    |> Enum.zip(to_mask)
    |> Enum.map(&mask_bit/1)
    |> Integer.undigits(2)
  end

  def mask2(value, %{mask: mask}) do
    digits = Integer.digits(value, 2)
    len = length(digits)
    to_mask = List.duplicate(0, 36 - len) ++ digits
    idxs = 
      mask
      |> Enum.with_index()
      |> Enum.filter(fn {k, _idx} -> k == ?X end)
      |> Enum.map(& elem(&1, 1))
    for idx <- idxs,
        value <- [0,1],
        pair <- {idx, value}
    do
      {idx, value}
    end
    |> Enum.map(fn {idx, value} -> value end)
  end

  def mask_bit({?X,  bit}), do: bit
  def mask_bit({?1, _bit}), do: 1
  def mask_bit({?0, _bit}), do: 0
  
  def mask_bit2({?X, _bit}), do: ?X
  def mask_bit2({?1, _bit}), do: 1
  def mask_bit2({?0,  bit}), do: bit

end