defmodule Calculator do
  def sum(a, b \\ 0) do
    a + b
  end
end

defmodule MyModule do
  def fun(a, b \\ 1, c, d \\ 2) do
    IO.inspect(%{a: a, b: b, c: c, d: d})
    a + b + c + d
  end
end
