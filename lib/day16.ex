defmodule Day16 do

  def part1 do
    %{rules: rules, nearby: tickets} = input()
    
    tickets
    |> Enum.flat_map(& &1)
    |> Enum.reject(fn x -> Enum.any?(rules, fn rule -> rule.func.(x) end) end)
    |> Enum.sum()
  end

  def input do
    "day16.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> parse_chunks()
  end

  def parse_chunks([rules, ticket, others]) do
    %{
      rules: parse_rules(rules),
      ticket: hd(parse_tickets(ticket)),
      nearby: parse_tickets(others)
    }
  end

  def parse_rules(rules), do: Enum.map(String.split(rules, "\n", trim: true), &parse_rule/1)

  def parse_rule(rule) do
    [name | bound_strs] = String.split(rule, [": ", "-", " or "], trim: true)
    [ll1, ul1, ll2, ul2] = Enum.map(bound_strs, &String.to_integer/1)
    %{name: name, func: (fn x -> (x >= ll1 and x <= ul1) or (x >= ll2 and x <= ul2) end)}
  end

  def parse_tickets(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.drop(1)
    |> Enum.map(fn line -> 
        Enum.map(String.split(line, ",", trim: true), &String.to_integer/1) 
       end)
  end

end