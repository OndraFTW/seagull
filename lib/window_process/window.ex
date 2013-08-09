defmodule WindowProcess.Window do

  def respond(object, :get_size, []), do: :wxWindow.getSize(Keyword.get(object, :wxobject))
  def respond(object, :set_size, size), do: :wxWindow.setSize(Keyword.get(object, :wxobject), size)
  def respond(object, :get_position, []), do: :wxWindow.getPosition(Keyword.get(object, :wxobject))
  def respond(object, funct, options), do: WindowProcess.EventHandler.respond(object, funct, options)

end
