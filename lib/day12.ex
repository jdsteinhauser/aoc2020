defmodule Day12 do

  @directions [:N, :E, :S, :W]

  def part1, do: Enum.reduce(input(), %{heading: :E, location: {0,0}}, fn x, acc -> move1(acc, x) end)
  def part2, do: Enum.reduce(input(), %{ship: {0,0}, waypoint: {10,-1}}, fn x, acc -> move2(acc, x) end)

  def input do
    "day12.txt"
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(& String.split_at(&1, 1))
    |> Enum.map(fn {dir,x} -> %{direction: String.to_atom(dir), distance: String.to_integer(x)} end)
  end

  def move1(%{heading: head, location: {x,y}}, %{direction: :N, distance: d}), do: %{heading: head, location: {x  , y-d}}
  def move1(%{heading: head, location: {x,y}}, %{direction: :E, distance: d}), do: %{heading: head, location: {x+d, y}}
  def move1(%{heading: head, location: {x,y}}, %{direction: :S, distance: d}), do: %{heading: head, location: {x,   y+d}}
  def move1(%{heading: head, location: {x,y}}, %{direction: :W, distance: d}), do: %{heading: head, location: {x-d, y}}
  
  def move1(%{heading: head, location: loc}, %{direction: :F, distance: d}) do
    move1(%{heading: head, location: loc}, %{direction: head, distance: d})
  end

  def move1(%{heading: head, location: loc}, %{direction: :L, distance: d}) do
    idx = Enum.find_index(@directions, & &1 == head)
    %{heading: Enum.at(@directions,rem(idx + 4 - Integer.floor_div(d, 90), 4)), location: loc}
  end

  def move1(%{heading: head, location: loc}, %{direction: :R, distance: d}) do
    idx = Enum.find_index(@directions, & &1 == head)
    %{heading: Enum.at(@directions, rem(idx + Integer.floor_div(d, 90), 4)), location: loc}
  end

  def move2(%{ship: ship, waypoint: {x, y}}, %{direction: :N, distance: d}) do
    %{ship: ship, waypoint: {x, y-d}}
  end

  def move2(%{ship: ship, waypoint: {x, y}}, %{direction: :E, distance: d}) do
    %{ship: ship, waypoint: {x+d, y}}
  end

  def move2(%{ship: ship, waypoint: {x, y}}, %{direction: :S, distance: d}) do
    %{ship: ship, waypoint: {x, y+d}}
  end

  def move2(%{ship: ship, waypoint: {x, y}}, %{direction: :W, distance: d}) do
    %{ship: ship, waypoint: {x-d, y}}
  end

  def move2(%{ship: {x0, y0}, waypoint: {x1, y1}}, %{direction: :F, distance: d}) do
    %{ship: {x0 + x1*d, y0 + y1*d}, waypoint: {x1, y1}}
  end

  def move2(%{ship: ship, waypoint: {x,y}}, %{direction: :L, distance: d}) do
    rotate_amount = Integer.floor_div(d, 90)
    # Subract from east (+x, idx 1)
    x_dir = Enum.at(@directions, rem(1 - rotate_amount + 4, 4))
    # Subtract from south (+y, idx 2)
    y_dir = Enum.at(@directions, rem(2 - rotate_amount + 4, 4))
    %{ship: ship, waypoint: {0,0}}
    |> move2(%{direction: x_dir, distance: x})
    |> move2(%{direction: y_dir, distance: y})
  end

  def move2(%{ship: ship, waypoint: {x,y}}, %{direction: :R, distance: d}) do
    rotate_amount = Integer.floor_div(d, 90)
    # Add to east (+x, idx 1)
    x_dir = Enum.at(@directions, rem(1 + rotate_amount, 4))
    # Add to from south (+y, idx 2)
    y_dir = Enum.at(@directions, rem(2 + rotate_amount, 4))
    %{ship: ship, waypoint: {0,0}}
    |> move2(%{direction: x_dir, distance: x})
    |> move2(%{direction: y_dir, distance: y})
  end

end