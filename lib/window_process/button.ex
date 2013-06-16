defmodule WindowProcess.Button do

  def respond(object, :get_label, []), do: :wxControl.getLabel object
  def respond(object, :set_label, label), do: :wxControl.setLabel object, label
  def respond(object, :get_size, []), do: :wxWindow.getSize object
  def respond(object, :set_size, size), do: :wxWindow.setSize object, size
  def respond(_object, _func, _params), do: :uknown_function

end
