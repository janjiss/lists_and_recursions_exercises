defmodule ListsAndRecursion_5Test do
  use ExUnit.Case

  test :all? do
    assert ListsAndRecursion_5.all?([2, 4, 6], fn(x) -> rem(x, 2) == 0 end)
    refute ListsAndRecursion_5.all?([2, 3, 4], fn(x) -> rem(x, 2) == 0 end)
    assert ListsAndRecursion_5.all?([2, 4, 6])
    refute ListsAndRecursion_5.all?([2, nil, 4])
    assert ListsAndRecursion_5.all?([])
  end

  test :each do
    assert ListsAndRecursion_5.each([], fn(x) -> x end) == :ok
    assert ListsAndRecursion_5.each([1, 2, 3], fn(x) -> Process.put(:enum_test_each, x * 2) end) == :ok
    assert Process.get(:enum_test_each) == 6
  after
    Process.delete(:enum_test_each)
  end

  test :filter do
    assert ListsAndRecursion_5.filter([1, 2, 3], fn(x) -> rem(x, 2) == 0 end) == [2]
    assert ListsAndRecursion_5.filter([2, 4, 6], fn(x) -> rem(x, 2) == 0 end) == [2, 4, 6]
  end

  test :split do
    assert ListsAndRecursion_5.split([1, 2, 3], 0) == { [], [1, 2, 3]  }
    assert ListsAndRecursion_5.split([1, 2, 3], 1) == { [1], [2, 3]  }
    assert ListsAndRecursion_5.split([1, 2, 3], 2) == { [1, 2], [3]  }
    assert ListsAndRecursion_5.split([1, 2, 3], 3) == { [1, 2, 3], []  }
    assert ListsAndRecursion_5.split([1, 2, 3], 4) == { [1, 2, 3], []  }
    assert ListsAndRecursion_5.split([], 3) == { [], []  }
    assert ListsAndRecursion_5.split([1, 2, 3], -1) == { [1, 2], [3]  }
    assert ListsAndRecursion_5.split([1, 2, 3], -2) == { [1], [2, 3]  }
    assert ListsAndRecursion_5.split([1, 2, 3], -3) == { [], [1, 2, 3]  }
    assert ListsAndRecursion_5.split([1, 2, 3], -10) == { [], [1, 2, 3]  }
  end

  test :take do
    assert ListsAndRecursion_5.take([1, 2, 3], 0) == []
    assert ListsAndRecursion_5.take([1, 2, 3], 1) == [1]
    assert ListsAndRecursion_5.take([1, 2, 3], 2) == [1, 2]
    assert ListsAndRecursion_5.take([1, 2, 3], 3) == [1, 2, 3]
    assert ListsAndRecursion_5.take([1, 2, 3], 4) == [1, 2, 3]
    assert ListsAndRecursion_5.take([1, 2, 3], -1) == [3]
    assert ListsAndRecursion_5.take([1, 2, 3], -2) == [2, 3]
    assert ListsAndRecursion_5.take([1, 2, 3], -4) == [1, 2, 3]
    assert ListsAndRecursion_5.take([], 3) == []
  end

  test :flatten do
    assert ListsAndRecursion_5.flatten([1, 2, 3]) == [1, 2, 3]
    assert ListsAndRecursion_5.flatten([1, [2], 3]) == [1, 2, 3]
    assert ListsAndRecursion_5.flatten([[1, [2], 3]]) == [1, 2, 3]
    assert ListsAndRecursion_5.flatten([]) == []
    assert ListsAndRecursion_5.flatten([[]]) == []
  end

  test :process_orders do
    tax_rates = [NC: 0.075, TX: 0.08]
    assert(ListsAndRecursion_5.process_orders ==
    [
      [id: 123, ship_to: :NC, net_amount: 100+100.00*tax_rates[:NC]],
      [id: 124, ship_to: :OK, net_amount: 35.50],
      [id: 125, ship_to: :TX, net_amount: 24+24.00*tax_rates[:TX]],
      [id: 126, ship_to: :TX, net_amount: 44.8+44.80*tax_rates[:TX]],
      [id: 127, ship_to: :NC, net_amount: 25+25.00*tax_rates[:NC]],
      [id: 128, ship_to: :MA, net_amount: 10.00],
      [id: 129, ship_to: :CA, net_amount: 102.00],
      [id: 130, ship_to: :NC, net_amount: 50+50.00*tax_rates[:NC]]
      ]
    )
  end
end
