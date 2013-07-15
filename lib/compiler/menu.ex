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
    data=[type: :menu, wxobject: wxitem, id: id, pid: my_pid]++data
    compile_options(data, post)
    children=Compiler.compile_children children, [wxparent: wxitem, parent: id, pid: children_pid], []
    [{id, data}|children]
  end

  defp divide_options(options), do: divide_options options,  [], []
  defp divide_options([], pre, post), do: {pre, post}
  defp divide_options([{:pid, _}|tail], pre, post), do: divide_options tail, pre, post
  defp divide_options([{:children_pid, _}|tail], pre, post), do: divide_options tail, pre, post
  defp divide_options([{:react, events}|tail], pre, post), do: divide_options tail, pre, [{:react, events}|post]
  
  defp compile_options(_data, []), do: nil
  defp compile_options(data, [head|tail]) do
    compile_option data, head
    compile_options data, tail
  end

  defp compile_option(data, {:react, events}), do: react data, events

  defp react(_data, []), do: true
  defp react(data, [event|tail]) do
    if Event.Menu.react(data, event) do
      react data, tail
    else
      raise {:uknown_event, event}
    end
  end

end
