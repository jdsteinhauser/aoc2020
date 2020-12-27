defmodule Day17 do

  @legend %{?. => :inactive, ?# => :active}

  def part1 do
    input()
    |> Stream.iterate(&transform/1)
    |> Stream.drop(6)
    |> Enum.at(0)
    |> Enum.count(fn {_,value} -> :active == value end)
  end

  def part2 do
    input()
    |> Map.new(fn {{x,y,z}, v} -> {{x,y,z,0}, v} end)
    |> Stream.iterate(&transform2/1)
    |> Stream.drop(6)
    |> Enum.at(0)
    |> Enum.count(fn {_,value} -> :active == value end)
  end

  def input do
    "day17.txt"
    |> File.stream!()
    |> Enum.with_index()
    |> Enum.flat_map(&xform_line/1)
    |> Map.new()
  end

  def xform_line({line, y_idx}) do
    line
    |> to_charlist()
    |> Enum.map(& Map.get(@legend, &1, :inactive))
    |> Enum.with_index()
    |> Enum.map(fn {value, x_idx} -> {{x_idx, y_idx, 0}, value} end)
  end

  def transform(matrix) do
    {{min_x, _,     _},     {max_x,     _, _}} = Enum.min_max_by(Map.keys(matrix), & elem(&1, 0))
    {{_,     min_y, _},     {_,     max_y, _}} = Enum.min_max_by(Map.keys(matrix), & elem(&1, 1))
    {{ _,    _,     min_z}, {_,         _, max_z}} = Enum.min_max_by(Map.keys(matrix), & elem(&1, 2))
    for x <- min_x-1..max_x+1, y <- min_y-1..max_y+1, z <- min_z-1..max_z+1
    do
      transform_cell(x, y, z, Map.get(matrix, {x, y, z}, :inactive), occupied_neighbors(matrix, {x,y,z}))
    end
    |> Map.new()
  end

  def occupied_neighbors(matrix, {cx,cy,cz}) do
    for x <- cx-1..cx+1, y <- cy-1..cy+1, z <- cz-1..cz+1
    do
      {x,y,z}
    end
    |> Enum.reject(& &1 == {cx,cy,cz})
    |> Enum.map(& Map.get(matrix, &1, :inactive))
    |> Enum.count(& &1 == :active)
  end

  def transform_cell(x, y, z, :active, count) when count == 2 or count == 3, do: {{x,y,z}, :active}
  def transform_cell(x, y, z, :inactive, count) when count == 3, do: {{x,y,z}, :active}
  def transform_cell(x, y, z, _, _), do: {{x,y,z}, :inactive}

  def transform2(matrix) do
    {{min_x,     _,     _,     _}, {max_x,     _,     _,     _}} = Enum.min_max_by(Map.keys(matrix), & elem(&1, 0))
    {{    _, min_y,     _,     _}, {    _, max_y,     _,     _}} = Enum.min_max_by(Map.keys(matrix), & elem(&1, 1))
    {{    _,     _, min_z,     _}, {    _,     _, max_z,     _}} = Enum.min_max_by(Map.keys(matrix), & elem(&1, 2))
    {{    _,     _,     _, min_w}, {    _,     _,     _, max_w}} = Enum.min_max_by(Map.keys(matrix), & elem(&1, 3))
    for x <- min_x-1..max_x+1, y <- min_y-1..max_y+1, z <- min_z-1..max_z+1, w <- min_w-1..max_w+1
    do
      transform_cell2(x, y, z, w, Map.get(matrix, {x, y, z, w}, :inactive), occupied_neighbors2(matrix, {x,y,z,w}))
    end
    |> Map.new()
  end

  def occupied_neighbors2(matrix, {cx,cy,cz,cw}) do
    for x <- cx-1..cx+1, y <- cy-1..cy+1, z <- cz-1..cz+1, w <- cw-1..cw+1
    do
      {x,y,z,w}
    end
    |> Enum.reject(& &1 == {cx,cy,cz,cw})
    |> Enum.map(& Map.get(matrix, &1, :inactive))
    |> Enum.count(& &1 == :active)
  end

  def transform_cell2(x, y, z, w, :active, count) when count == 2 or count == 3, do: {{x,y,z,w}, :active}
  def transform_cell2(x, y, z, w, :inactive, count) when count == 3, do: {{x,y,z,w}, :active}
  def transform_cell2(x, y, z, w, _, _), do: {{x,y,z,w}, :inactive}

end