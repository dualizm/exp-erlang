defmodule Geometry do
  defmodule Rectangle do
    def area(a, b) do
      a * b
    end
  end

  defmodule Square do
    def area(a) do
      Rectangle.area(a, a)
    end
  end
end
