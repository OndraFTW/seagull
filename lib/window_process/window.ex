defmodule WindowProcess.Window do

  def respond(object, :get_size, []), do: :wxWindow.getSize object
  def respond(object, :set_size, size), do: :wxWindow.setSize object, size
  def respond(object, :get_position, []), do: :wxWindow.getPosition object
  def respond(object, funct, options), do: WindowProcess.EventHandler.respond object, funct, options

end
