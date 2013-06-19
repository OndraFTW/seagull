defmodule WindowProcess.TopLevelWindow do

  def respond(object, :get_title, []), do: list_to_binary :wxTopLevelWindow.getTitle(Keyword.get(object, :wxobject))
  def respond(object, :set_title, title), do: :wxTopLevelWindow.setTitle Keyword.get(object, :wxobject), binary_to_list(title)
  def respond(object, func, options), do: WindowProcess.Window.respond object, func, options

end
