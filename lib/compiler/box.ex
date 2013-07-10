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
    compile_options(wxitem, id, post, my_pid)
    {:wx_ref, r, :wxSizer, []} = :wxWindow.getSizer parent
    if r==0, do: :wxWindow.setSizer parent, wxitem
    children=Compiler.compile_box_children children, [wxparent: parent, parent: id, wxbox: wxitem, pid: children_pid], []
    [{id, [type: :box, wxobject: wxitem, id: id, pid: my_pid]++data}|children]
  end

  defp divide_options(options), do: divide_options options,  [], []
  defp divide_options([], pre, post), do: {pre, post}
  defp divide_options([{:pid, _}|tail], pre, post), do: divide_options tail, pre, post
  defp divide_options([{:children_pid, _}|tail], pre, post), do: divide_options tail, pre, post
  
  def compile_options(_box, _id, [], _pid), do: nil

end
