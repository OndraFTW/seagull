defmodule WindowProcess.Sizer do

  def respond(_object, :append, item) do
    IO.inspect item
  end
  def respond(object, func, options),
    do: WindowProcess.Object.respond object, func, options

end
