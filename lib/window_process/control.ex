defmodule WindowProcess.Control do

  def respond(object, :get_label, []), do: list_to_binary :wxControl.getLabel(Keyword.get(object, :wxobject))
  def respond(object, :set_label, label) when is_list(label), do: :wxControl.setLabel Keyword.get(object, :wxobject), label
  def respond(object, :set_label, label), do: :wxControl.setLabel Keyword.get(object, :wxobject), binary_to_list(label)
  def respond(object, func, options), do: WindowProcess.Window.respond object, func, options

end
