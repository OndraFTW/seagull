defmodule Compiler.Menu do
  require Constant

  def compile(id, title, options, children, data) do
    if id==:_, do: id=Compiler.random_id
    {pre, post}=divide_options options
    wxitem = :wxMenu.new pre
    :wxMenuBar.append Keyword.get(data, :wxparent), wxitem, binary_to_list(title)
    pid=Keyword.get data, :pid
    data=Keyword.delete data, :pid
    children_pid=Keyword.get options, :children_pid, pid
    my_pid=Keyword.get options, :pid, pid
    compile_options(wxitem, id, post, my_pid)
    children=Compiler.compile_children children, [wxparent: wxitem, parent: id, pid: children_pid], []
    [{id, [type: :menu, wxobject: wxitem, id: id, pid: my_pid]++data}|children]
  end

  defp divide_options(options), do: divide_options options,  [], []
  defp divide_options([], pre, post), do: {pre, post}
  defp divide_options([{:pid, _}|tail], pre, post), do: divide_options tail, pre, post
  defp divide_options([{:children_pid, _}|tail], pre, post), do: divide_options tail, pre, post
  
  def compile_options(_box, _id, [], _pid), do: nil

end
