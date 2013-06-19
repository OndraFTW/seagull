defmodule WindowProcess.Sizer do

  def respond(object, :append, item) do
    [{_id, compiled_item}] = Compiler.compile_child item, wxparent: Keyword.get(object, :wxparent),
      wxbox: Keyword.get(object, :wxobject), parent: Keyword.get(object, :id), pid: Keyword.get(object, :pid)
    :wxSizer.add Keyword.get(object, :wxobject), Keyword.get(compiled_item, :wxobject)
    :wxSizer.layout Keyword.get(object, :wxobject)
  end
  def respond(object, :prepend, item) do
    [{_id, compiled_item}] = Compiler.compile_child item, wxparent: Keyword.get(object, :wxparent),
      wxbox: Keyword.get(object, :wxobject), parent: Keyword.get(object, :id), pid: Keyword.get(object, :pid)
    :wxSizer.prepend Keyword.get(object, :wxobject), :wxSizerItem.new(Keyword.get(compiled_item, :wxobject), :wxSizerFlags.new())
    :wxSizer.layout Keyword.get(object, :wxobject)
  end
  def respond(object, func, options),
    do: WindowProcess.Object.respond object, func, options

end
