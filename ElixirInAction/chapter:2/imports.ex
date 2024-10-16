defmodule MyModule do
  import IO

  alias IO, as: MyIO
  alias Geometry.Rectangle

  def my_fun do
    puts "Calling imported function."
  end

  def my_fun2 do
    MyIO.puts("Calling imported function.")
  end

  def my_fun3 do
    Rectangle.area(10,10)
  end

end
