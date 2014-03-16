defmodule ListsAndRecursion_5 do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    ListsAndRecursion_5.Supervisor.start_link
  end

  def all?([head | tail]) do
    if head do
      all?(tail)
    else
      false
    end
  end

  def all?([]) do
    true
  end

  def all?(col, fun) when is_function(fun) do
    do_all?(col, fun, true)
  end

  defp do_all?([head | tail], fun, _) do
    if fun.(head) do
      do_all?(tail, fun, fun.(head))
    else
      false
    end
  end

  defp do_all?([], _, _) do
    true
  end


  # Each 

  def each([head | tail], fun) do
    fun.(head)
    each(tail, fun)
  end

  def each([], _) do
    :ok
  end

  # Filter 

  def filter(col, fun) do
    do_filter(col, fun, []) 
  end

  defp do_filter([head | tail], fun, col) do
    if fun.(head) do
      do_filter(tail, fun, [head | col])
    else
      do_filter(tail, fun, col)
    end
  end
 
  defp do_filter([], _, col) do
    :lists.reverse(col)
  end

  # Split

  def split(col, count) do
    if count >= 0 do
      do_split(col, count, 0, []) 
    else
      do_reverse_split(:lists.reverse(col), abs(count), 0, []) 
    end
  end

  def do_split(tail_col, count, step, head_col) when step == count do
    {:lists.reverse(head_col), tail_col}
  end

  def do_split([], _, _, head_col) do
    {:lists.reverse(head_col), []}
  end

  def do_split([head | tail], count, step, head_col) do
    do_split(tail, count, step + 1, [head | head_col])
  end

  def do_reverse_split(tail_col, count, step, head_col) when step == count do
    {:lists.reverse(tail_col), head_col}
  end

  def do_reverse_split([], _, _, head_col) do
    {[], head_col}
  end

  def do_reverse_split([head | tail], count, step, head_col) do
    do_reverse_split(tail, count, step + 1, [head | head_col])
  end

  # Take 

  def take(col, count) do
    {head, tail} = split(col, count)
    if count >= 0 do
      head
    else
      tail
    end
  end

  # Flatten

  def flatten(list) do
    do_flatten(list, [])
  end

  def do_flatten([], acc) do
    :lists.reverse(acc)
  end

  def do_flatten([head | tail], acc) when is_list(head) do
    Enum.concat(do_flatten(head, acc), tail)
  end

  def do_flatten([head | tail], acc) do
    do_flatten(tail, [head | acc])
  end


  # Lists and recursions 8

  def tax_rates do
    [NC: 0.075, TX: 0.08]
  end

  def orders do
    [
      [id: 123, ship_to: :NC, net_amount: 100.00],
      [id: 124, ship_to: :OK, net_amount: 35.50],
      [id: 125, ship_to: :TX, net_amount: 24.00],
      [id: 126, ship_to: :TX, net_amount: 44.80],
      [id: 127, ship_to: :NC, net_amount: 25.00],
      [id: 128, ship_to: :MA, net_amount: 10.00],
      [id: 129, ship_to: :CA, net_amount: 102.00],
      [id: 130, ship_to: :NC, net_amount: 50.00]
    ]
  end

  def process_orders do
    do_process_orders(orders, [])
  end

  def do_process_orders([], acc) do
    :lists.reverse(acc)
  end

  def do_process_orders([head | tail], acc) do
    net_amount = apply_tax(head[:net_amount], head[:ship_to])
    do_process_orders(tail, [[id: head[:id], ship_to: head[:ship_to], net_amount: net_amount]| acc]) 
  end

  def apply_tax(sum, state) do
    if tax_rates[state] do
      sum + sum * tax_rates[state]
    else
      sum
    end
  end


end
