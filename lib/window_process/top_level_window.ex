defmodule WindowProcess.TopLevelWindow do

  def respond(object, :get_title, []), do: list_to_binary(:wxTopLevelWindow.getTitle(Keyword.get(object, :wxobject)))
  def respond(object, :set_title, title), do: :wxTopLevelWindow.setTitle(Keyword.get(object, :wxobject), binary_to_list(title))
  def respond(object, :maximize, []), do: :wxTopLevelWindow.maximize(Keyword.get(object, :wxobject))
  def respond(object, :is_maximized, []), do: :wxTopLevelWindow.isMaximized(Keyword.get(object, :wxobject))
  def respond(object, :minimize, []), do: :wxTopLevelWindow.iconize(Keyword.get(object, :wxobject))
  def respond(object, :is_minimized, []), do: :wxTopLevelWindow.isIconized(Keyword.get(object, :wxobject))
  def respond(object, :show_fullscreen, []), do: :wxTopLevelWindow.showFullScreen(Keyword.get(object, :wxobject), true)
  def respond(object, :close_fullscreen, []), do: :wxTopLevelWindow.showFullScreen(Keyword.get(object, :wxobject), false)
  def respond(object, func, options), do: WindowProcess.Window.respond(object, func, options)

end
