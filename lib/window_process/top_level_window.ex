defmodule WindowProcess.TopLevelWindow do

  def respond(object, :get_title, []), do: to_string(:wxTopLevelWindow.getTitle(Keyword.get(object, :wxobject)))
  def respond(object, :set_title, title) do
    :wxTopLevelWindow.setTitle(Keyword.get(object, :wxobject), to_char_list(title))
    {compiled, tree}=Keyword.get(object, :window)
    id=Keyword.get object, :id
    tree=Widget.modify_tree tree, id, fn({type, req, options, children})->
      {type, req, Keyword.put(options, :title, title), children}
    end
    {:response_and_window, :ok, {compiled, tree}}
  end
  def respond(object, :maximize, []), do: :wxTopLevelWindow.maximize(Keyword.get(object, :wxobject))
  def respond(object, :is_maximized, []), do: :wxTopLevelWindow.isMaximized(Keyword.get(object, :wxobject))
  def respond(object, :minimize, []), do: :wxTopLevelWindow.iconize(Keyword.get(object, :wxobject))
  def respond(object, :is_minimized, []), do: :wxTopLevelWindow.isIconized(Keyword.get(object, :wxobject))
  def respond(object, :show_fullscreen, []), do: :wxTopLevelWindow.showFullScreen(Keyword.get(object, :wxobject), true)
  def respond(object, :close_fullscreen, []), do: :wxTopLevelWindow.showFullScreen(Keyword.get(object, :wxobject), false)
  def respond(object, func, options), do: WindowProcess.Window.respond(object, func, options)

end
