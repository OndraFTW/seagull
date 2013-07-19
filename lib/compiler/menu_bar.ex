defmodule Compiler.MenuBar do
  require Constant

  def compile(id, options, children, data) do
    if id==:_, do: id=Compiler.random_id
    {_pre, post}=divide_options options
    wxitem = :wxMenuBar.new
    pid=Keyword.get data, :pid
    data=Keyword.delete data, :pid
    children_pid=Keyword.get options, :children_pid, pid
    my_pid=Keyword.get options, :pid, pid
    data=[type: :menu_bar, wxobject: wxitem, id: id, pid: my_pid]++data
    compile_options(data, post)
    children=Compiler.compile_children children, [wxparent: wxitem, parent: id, pid: children_pid], []
    :wxFrame.setMenuBar Keyword.get(data, :wxparent), wxitem
    [{id, data}|children]
  end

  defp divide_options(options), do: divide_options options,  [], []
  defp divide_options([], pre, post), do: {pre, post}
  defp divide_options([{:pid, _}|tail], pre, post), do: divide_options tail, pre, post
  defp divide_options([{:children_pid, _}|tail], pre, post), do: divide_options tail, pre, post
  
  def compile_options(_data, []), do: nil

end
