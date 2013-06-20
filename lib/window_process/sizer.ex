defmodule WindowProcess.Sizer do

  def respond(object, :append, item) do
    [{id, compiled_item}|grandchildren] = Compiler.compile_child item, wxparent: Keyword.get(object, :wxparent),
      wxbox: Keyword.get(object, :wxobject), parent: Keyword.get(object, :id), pid: Keyword.get(object, :pid)
    :wxSizer.add Keyword.get(object, :wxobject), Keyword.get(compiled_item, :wxobject)
    :wxSizer.layout Keyword.get(object, :wxobject)
    {:response_window, :ok, [{id, compiled_item}|grandchildren]++Keyword.get(object, :window)}
  end
  def respond(object, :prepend, item) do
    [{id, compiled_item}|grandchildren] = Compiler.compile_child item, wxparent: Keyword.get(object, :wxparent),
      wxbox: Keyword.get(object, :wxobject), parent: Keyword.get(object, :id), pid: Keyword.get(object, :pid)
    :wxSizer.prepend Keyword.get(object, :wxobject), :wxSizerItem.new(Keyword.get(compiled_item, :wxobject), :wxSizerFlags.new())
    :wxSizer.layout Keyword.get(object, :wxobject)
    {:response_window, :ok, [{id, compiled_item}|grandchildren]++Keyword.get(object, :window)}
  end
  def respond(object, func, options),
    do: WindowProcess.Object.respond object, func, options

end
