defmodule WindowProcess.Control do

  def respond(object, :get_label, []), do: :wxControl.getLabel object
  def respond(object, :set_label, label), do: :wxControl.setLabel object, label
  def respond(object, func, options), do: WindowProcess.Window.respond object, func, options

end
