defmodule Compiler.Frame do
  import Constant

  def compile(id, title, options, children, data) do
    if is_binary(title), do: title=binary_to_list title
    if id==:_, do: id=Compiler.random_id
    {pre, post}=divide_options options
    pre=Compiler.fuse_styles pre
    pid=Keyword.get data, :pid
    data=Keyword.delete data, :pid
    children_pid=Keyword.get options, :children_pid, pid
    my_pid=Keyword.get options, :pid, pid
    parent=Keyword.get data, :wxparent
    wxitem = :wxFrame.new parent, Constant.wxID_ANY, title, pre
    data=[type: :frame, wxobject: wxitem, id: id, pid: my_pid]++data
    compile_options(wxitem, id, post, my_pid)
    menu_bar=compile_menu_bar data, Keyword.get(options, :menu_bar, nil)
    children=Compiler.compile_children children, [wxparent: wxitem, parent: id, pid: children_pid], []
    [{id, data}|menu_bar]++children
  end

  defp compile_menu_bar(_data, nil) do
    []
  end
  defp compile_menu_bar(data, mb) do
    Compiler.compile_child mb, [wxparent: Keyword.get(data, :wxobject), parent: Keyword.get(data, :id), pid: Keyword.get(data, :pid)]
  end

  defp divide_options(options), do: divide_options options, [], []
  defp divide_options([], pre, post), do: {pre, post}
  defp divide_options([{:position, {x, y}}|tail], pre, post), do: divide_options tail, [{:pos, {x, y}}|pre], post
  defp divide_options([{:size, {w, h}}|tail], pre, post), do: divide_options tail, [{:size, {w, h}}|pre], post
  defp divide_options([{:react, events}|tail], pre, post), do: divide_options tail, pre, [{:react, events}|post]
  defp divide_options([{:pid, _}|tail], pre, post), do: divide_options tail, pre, post
  defp divide_options([{:children_pid, _}|tail], pre, post), do: divide_options tail, pre, post
  defp divide_options([{:menu_bar, _}|tail], pre, post), do: divide_options tail, pre, post
  defp divide_options([{:border, border}|tail], pre, post) do
    o=case border do
      :default->wxBORDER_DEFAULT
      :simple->wxBORDER_SIMPLE
      :double->wxBORDER_DOUBLE
      :sunken->wxBORDER_SUNKEN
      :raised->wxBORDER_RAISED
      :static->wxBORDER_STATIC
      :theme->wxBORDER_THEME
      :none->wxBORDER_NONE
      :mask->wxBORDER_MASK
    end
    divide_options tail, [{:style, o}|pre], post
  end
  
  defp compile_options(_frame, _id, [], _pid), do: nil
  defp compile_options(frame, id, [head|tail], pid) do
    compile_option frame, id, head, pid
    compile_options frame, id, tail, pid
  end

  defp compile_option(frame, id, {:react, events}, pid) do
    if not Enum.member?(events, :closed) do
      my_pid=self
      :wxEvtHandler.connect frame, :close_window, [{:callback, fn(_, _)-> my_pid<-:destroy end}]
    end
    react frame, id, events, pid
  end

  defp react(_frame, _id, [], _pid), do: nil
  defp react(frame, id, [event|tail], pid) do
    if Event.Frame.react(frame, id, event, pid) or
      Event.Mouse.react(frame, id, event, pid) or
      Event.TopLevelWindow.react(frame, id, event, pid) do
      react frame, id, tail, pid
    else
      raise {:uknown_event, event}
    end
  end

end
