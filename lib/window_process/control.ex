defmodule WindowProcess.Control do

  def respond(object, :get_label, []), do: to_string( :wxControl.getLabel(Keyword.get(object, :wxobject)))
  def respond(object, :set_label, label) do
    :wxControl.setLabel(Keyword.get(object, :wxobject), to_char_list(label))
    {compiled, tree}=Keyword.get object, :window
    id=Keyword.get(object, :id)
    tree=Widget.modify_tree tree, id, fn({type, id, options, children})->
      {type, id, Keyword.put(options, :label, label), children}
    end
    {:response_and_window, :ok, {compiled, tree}}
  end
  def respond(object, func, options), do: WindowProcess.Window.respond(object, func, options)

end
