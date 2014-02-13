defmodule Compiler do

  @moduledoc"Provides functions to compile records into wxObjects"

  require Constant
  require Bitwise

  @widgets [
    button: Compiler.Button,
    frame: Compiler.Frame,
    box: Compiler.Box,
    text_box: Compiler.TextBox,
    menu_bar: Compiler.MenuBar,
    menu: Compiler.Menu,
    menu_item: Compiler.MenuItem
  ]

  lc {widget, module} inlist @widgets do
    def compile_child({unquote(widget), compulsory, options, children}, data) do
      unquote(module).compile(compulsory, options, children, data)
    end
  end

  def compile({:frame, {id}, options, children}, pid) do
    Compiler.Frame.compile {id}, options, children, wxparent: :wx.null, pid: pid, parent: nil
  end
 
  def random_id() do
    :random.uniform(4294967295) |> integer_to_binary |> binary_to_atom
  end

  def fuse_styles(list), do: fuse_styles(list, 0, [])
  defp fuse_styles([], 0, result), do: result
  defp fuse_styles([], style, result), do: [{:style, style}|result]
  defp fuse_styles([{:style, val}|tail], style, result), do: fuse_styles(tail, Bitwise.bor(val, style), result)
  defp fuse_styles([o|tail], style, result), do: fuse_styles(tail, style, [o|result])

  def compile_children([], _data, result), do: result
  def compile_children([child|tail], data, result),
    do: compile_children(tail, data, compile_child(child, data)++result)
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
