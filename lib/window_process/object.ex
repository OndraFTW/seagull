defmodule WindowProcess.Object do
  def respond(object, :get_tree, []) do
    {_compiled, tree}=Keyword.get object, :window
    Widget.get_widget_from_tree(tree, Keyword.get(object, :id))
  end
  def respond(_object, funct, _options), do: raise({:no_response_found, funct})

end
