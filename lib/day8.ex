defmodule Day8 do

  def part1(), do: exec_part1(instructions(), 0, 0, MapSet.new())

  def part2() do
    insts = instructions()

    with_idx = 
      insts
      |> Enum.with_index()
      |> Enum.reject(fn {x,_} -> x == :acc end)

    with_idx
    |> Enum.map(fn {{inst, value}, idx} -> List.replace_at(insts, idx, {(if inst == :nop, do: :jmp, else: :nop), value}) end)
    |> Enum.find(fn xs -> exec_part2(xs, 0, 0, MapSet.new()) != false end)
    |> exec_part2(0,0, MapSet.new())
  end

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

  def exec_part2(inst, idx, acc, _executed) when idx >= length(inst), do: acc
  def exec_part2(inst, idx, acc, executed) do
    if MapSet.member?(executed, idx)
    do
      false
    else
      %{move: move, acc: new_acc} = execute(Enum.at(inst, idx), acc)
      exec_part2(inst, idx + move, new_acc, MapSet.put(executed, idx))
    end
  end

end