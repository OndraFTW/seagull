defmodule Compiler.Box do
  require Constant

  def compile(id, orientation, options, children, data) do
    o=case orientation do
      :vertical->Constant.wxVERTICAL
      :horizontal->Constant.wxHORIZONTAL
    end
    if id==:_, do: id=Compiler.random_id
    {_pre, post}=divide_options options
    wxitem = :wxBoxSizer.new o
    pid=Keyword.get data, :pid
    data=Keyword.delete data, :pid
    children_pid=Keyword.get options, :children_pid, pid
    my_pid=Keyword.get options, :pid, pid
    parent=Keyword.get data, :wxparent
    data=[type: :box, wxobject: wxitem, id: id, pid: my_pid]++data
    compile_options(data, post)
    {:wx_ref, r, :wxSizer, []} = :wxWindow.getSizer parent
    if r==0, do: :wxWindow.setSizer parent, wxitem
    children=Compiler.compile_box_children children, [wxparent: parent, parent: id, wxbox: wxitem, pid: children_pid], []
    [{id, data}|children]
  end

  defp divide_options(options), do: divide_options options,  [], []
  defp divide_options([], pre, post), do: {pre, post}
  defp divide_options([{:pid, _}|tail], pre, post), do: divide_options tail, pre, post
  defp divide_options([{:children_pid, _}|tail], pre, post), do: divide_options tail, pre, post
  
  defp compile_options(_data, []), do: nil

end
