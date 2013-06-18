defmodule WindowProcess.Control do

  def respond(object, :get_label, []), do: list_to_binary :wxControl.getLabel(object)
  def respond(object, :set_label, label) when is_list(label), do: :wxControl.setLabel object, label
  def respond(object, :set_label, label), do: :wxControl.setLabel object, binary_to_list(label)
  def respond(object, func, options), do: WindowProcess.Window.respond object, func, options

end
