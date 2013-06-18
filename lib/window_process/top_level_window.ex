defmodule WindowProcess.TopLevelWindow do

  def respond(object, :get_title, []), do: list_to_binary :wxTopLevelWindow.getTitle(object)
  def respond(object, :set_title, title), do: :wxTopLevelWindow.setTitle object, binary_to_list(title)
  def respond(object, func, options), do: WindowProcess.Window.respond object, func, options

end
