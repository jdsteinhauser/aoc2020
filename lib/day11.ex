defmodule Day11 do

  @legend %{?L => :empty, ?. => :floor, ?# => :occupied}

  def part1 do
    input()
    |> Stream.iterate(&transform1/1)
    |> Stream.chunk_every(2, 1)
    |> Stream.drop_while(fn [x,y] -> x != y end)
    |> Enum.take(1)
    |> hd()
    |> hd()
    |> Enum.count(fn {_,value} -> :occupied == value end)
  end

  def part2 do
    input()
    |> Stream.iterate(&transform2/1)
    |> Stream.chunk_every(2, 1)
    |> Stream.drop_while(fn [x,y] -> x != y end)
    |> Enum.take(1)
    |> hd()
    |> hd()
    |> Enum.count(fn {_,value} -> :occupied == value end)
  end

  def input do
    "day11.txt"
    |> File.stream!()
    |> Enum.with_index()
    |> Enum.flat_map(&xform_line/1)
    |> Map.new()
  end

  def xform_line({line, y_idx}) do
    line
    |> to_charlist()
    |> Enum.map(& Map.get(@legend, &1))
    |> Enum.with_index()
    |> Enum.map(fn {value, x_idx} -> {{x_idx, y_idx}, value} end)
  end

  def transform1(matrix) do
    matrix
    |> Enum.map(fn {{x,y}, value} -> 
        transform_cell1(x, y, value, occupied_neighbors(matrix, {x,y}))
      end)
    |> Map.new()
  end

  def transform2(matrix) do
    matrix
    |> Enum.map(fn {{x,y}, value} -> 
        transform_cell2(x, y, value, visible_neighbors(matrix, {x,y}))
      end)
    |> Map.new()
  end

  def occupied_neighbors(matrix, {cx,cy}) do
    for x <- cx-1..cx+1, y <- cy-1..cy+1
    do
      {x,y}
    end
    |> Enum.reject(& &1 == {cx,cy})
    |> Enum.map(& Map.get(matrix, &1, :na))
    |> Enum.count(& &1 == :occupied)
  end

  def visible_neighbors(matrix, {cx, cy}) do
    [
      visible?({cx-1, cy-1}, matrix, :nw),
      visible?({cx,   cy-1}, matrix, :n),
      visible?({cx+1, cy-1}, matrix, :ne),
      visible?({cx+1, cy},   matrix, :e),
      visible?({cx+1, cy+1}, matrix, :se),
      visible?({cx,   cy+1}, matrix, :s),
      visible?({cx-1, cy+1}, matrix, :sw),
      visible?({cx-1, cy},   matrix, :w)
    ]
    |> Enum.count(& &1)
  end

  def visible?(coord, matrix, direction) do
    case Map.get(matrix, coord, :na) do
      :na -> false
      :empty -> false
      :occupied -> true
      _ -> visible?(move(coord, direction), matrix, direction)
    end
  end

  def move({x,y}, :nw), do: {x-1, y-1}
  def move({x,y}, :n),  do: {x,   y-1}
  def move({x,y}, :ne), do: {x+1, y-1}
  def move({x,y}, :e),  do: {x+1, y}
  def move({x,y}, :se), do: {x+1, y+1}
  def move({x,y}, :s),  do: {x,   y+1}
  def move({x,y}, :sw), do: {x-1, y+1}
  def move({x,y}, :w),  do: {x-1, y}

  def transform_cell1(x, y, :empty, 0), do: {{x,y}, :occupied}
  def transform_cell1(x, y, :occupied, count) when count >=4, do: {{x,y}, :empty}
  def transform_cell1(x, y, state, _), do: {{x,y}, state}

  def transform_cell2(x, y, :empty, 0), do: {{x,y}, :occupied}
  def transform_cell2(x, y, :occupied, count) when count >=5, do: {{x,y}, :empty}
  def transform_cell2(x, y, state, _), do: {{x,y}, state}

end