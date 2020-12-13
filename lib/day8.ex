defmodule Day8 do

  def part1(), do: exec_part1(instructions(), 0, 0, MapSet.new())

  def instructions() do
    "day8.txt"
    |> File.stream!()
    |> Enum.map(fn s -> String.split(s,["\n", " "], trim: true) end)
    |> Enum.map(fn [x, v] -> {String.to_atom(x), String.to_integer(v)} end)
  end

  def execute({:nop, _value}, acc), do: %{move: 1, acc: acc}
  def execute({:jmp, value}, acc),  do: %{move: value, acc: acc}
  def execute({:acc, value}, acc),  do: %{move: 1, acc: acc + value}

  def exec_part1(inst, idx, acc, executed) do
    if MapSet.member?(executed, idx)
    do
      acc
    else
      %{move: move, acc: new_acc} = execute(Enum.at(inst, idx), acc)
      exec_part1(inst, idx + move, new_acc, MapSet.put(executed, idx))
    end
  end

end