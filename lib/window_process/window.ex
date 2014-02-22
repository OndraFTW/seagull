defmodule WindowProcess.Window do

  def respond(object, :get_size, []), do: :wxWindow.getSize(Keyword.get(object, :wxobject))
  def respond(object, :set_size, new_size) do
    :wxWindow.setSize(Keyword.get(object, :wxobject), new_size)
    {compiled, tree}=Keyword.get object, :window
    id=Keyword.get object, :id
    tree=Widget.modify_tree tree, id, fn({type, req, options, children})->
      {type, req, Keyword.put(options, :size, new_size), children}
    end
    {:response_and_window, :ok, {compiled, tree}}
  end
  def respond(object, :get_position, []), do: :wxWindow.getPosition(Keyword.get(object, :wxobject))
  def respond(object, funct, options), do: WindowProcess.EventHandler.respond(object, funct, options)

end
