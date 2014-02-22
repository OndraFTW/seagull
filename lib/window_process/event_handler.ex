defmodule WindowProcess.EventHandler do

  def respond(object, :react, event) do
    response=Event.react(object, event)
    {compiled, tree}=Keyword.get object, :window
    id=Keyword.get object, :id
    tree=Widget.modify_tree tree, id, fn({type, req, options, children})->
      react_list=[event|Keyword.get(options, :react, [])]
      {type, req, Keyword.put(options, :react, react_list), children}
    end
    {:response_and_window, response, {compiled, tree}}
  end
  def respond(object, :dont_react, event) do
    response=Event.dont_react(object, event)
    {compiled, tree}=Keyword.get object, :window
    id=Keyword.get object, :id
    tree=Widget.modify_tree tree, id, fn({type, req, options, children})->
      react_list=Keyword.get(options, :react, [])|>List.delete(event)
      {type, req, Keyword.put(options, :react, react_list), children}
    end
    {:response_and_window, response, {compiled, tree}}
  end
  def respond(object, funct, options), do: WindowProcess.Object.respond(object, funct, options)

end
