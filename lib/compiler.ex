defmodule Compiler do

  @moduledoc"Provides functions to compile records into wxObjects"

  require Constant

  def compile(Widget.Frame[id: id, title: title, options: options, children: children], pid//self) do
    Compiler.Frame.compile id, title, options, children, :wx.null, pid
  end

  defp compile_child(Widget.Frame[id: id, title: title, options: options, children: children], parent, pid) do
    Compiler.Frame.compile id, title, options, children, parent, pid
  end

  defp compile_child(Widget.Button[id: id, options: options], parent, pid) do
    Compiler.Button.compile id, options, parent, pid
  end

  defp compile_child(Widget.Box[id: id, orientation: orientation, options: options, children: children], parent, pid) do
    Compiler.Box.compile id, orientation, options, children, parent, pid
  end

  def compile_children([], _parent, result, _pid), do: result
  def compile_children([child|tail], parent, result, pid),
    do: compile_children tail, parent, compile_child(child, parent, pid)++result, pid
  def compile_children(child, parent, result, pid), do: compile_child(child, parent, pid)++result

  def compile_box_children([], _box, _parent, result, _pid), do: result
  def compile_box_children([child|tail], box, parent, result, pid) do
    [chead|ctail]=compile_child child, parent, pid
    {_cid, data}=chead
    :wxSizer.add box, Keyword.get(data, :wxobject)
    [chead|ctail]++compile_box_children(tail, box, parent, result, pid)
  end

end
