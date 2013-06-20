defmodule Compiler do

  @moduledoc"Provides functions to compile records into wxObjects"

  require Constant

  def compile(Widget.Frame[id: id, title: title, options: options, children: children], pid//self) do
    Compiler.Frame.compile id, title, options, children, wxparent: :wx.null, pid: pid, parent: nil
  end

  def compile_child(Widget.Frame[id: id, title: title, options: options, children: children], data) do
    Compiler.Frame.compile id, title, options, children, data
  end

  def compile_child(Widget.Button[id: id, options: options], data) do
    Compiler.Button.compile id, options, data
  end

  def compile_child(Widget.Box[id: id, orientation: orientation, options: options, children: children], data) do
    Compiler.Box.compile id, orientation, options, children, data
  end

  def random_id() do
    :random.uniform(4294967295) |> integer_to_binary |> binary_to_atom
  end

  def compile_children([], _data, result), do: result
  def compile_children([child|tail], data, result),
    do: compile_children tail, data, compile_child(child, data)++result
  def compile_children(child, data, result),
    do: compile_child(child, data)++result

  def compile_box_children([], _data, result), do: result
  def compile_box_children([child|tail], data, result) do
    box=Keyword.get data, :wxbox
    [chead|ctail]=compile_child child, data
    {_cid, cdata}=chead
    :wxSizer.add box, Keyword.get(cdata, :wxobject)
    [chead|ctail]++compile_box_children(tail, data, result)
  end

end
