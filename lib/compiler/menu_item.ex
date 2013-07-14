defmodule Compiler.MenuItem do

  def compile(id, title, options, data) do
    if id==:_, do: id=Compiler.random_id
    {pre, post}=divide_options options
    pre=[{:text, binary_to_list(title)}|pre]
    pre=Compiler.fuse_styles pre
    pid=Keyword.get data, :pid
    data=Keyword.delete data, :pid
    my_pid=Keyword.get options, :pid, pid
    wxitem = :wxMenuItem.new pre
    {:wx_ref, wxitem_id, :wxMenuItem, _}=wxitem
    :wxMenu.append Keyword.get(data, :wxparent), wxitem_id, binary_to_list(title)
    compile_options(wxitem, id, post, my_pid)
    [{id, [type: :button, wxobject: wxitem, id: id, pid: my_pid]++data}]
  end

  defp divide_options(options), do: divide_options options, [], []
  defp divide_options([], pre, post), do: {pre, post}
  
  defp compile_options(_button, _id, [], _pid), do: true
  defp compile_options(button, id, [head|tail], pid) do
    compile_option button, id, head, pid
    compile_options button, id, tail, pid
  end

  defp compile_option(button, id, {:react, events}, pid), do: react button, id, events, pid

  defp react(_button, _id, [], _pid), do: true
  defp react(button, id, [event|tail], pid) do
    if Event.Mouse.react(button, id, event, pid) do
      react button, id, tail, pid
    else
      raise {:uknown_event, event}
    end
  end

end
