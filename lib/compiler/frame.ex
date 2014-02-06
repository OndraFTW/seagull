defmodule Compiler.Frame do
  import Constant

  def compile({id}, options, children, data) do
    title=''
    if Keyword.has_key?(options, :title) do
      title=to_char_list Keyword.get(options, :title)
      options=Keyword.delete options, :title
    end
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
    compile_options data, post
    secure_destroy wxitem, post
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

  defp secure_destroy(wxobject, options) do
    destroy=true
    react=Keyword.get options, :react, nil
    if react do
      if Enum.member?(react, :close) do
        destroy=false
      end
    end
    if destroy do
      my_pid=self
      :wxEvtHandler.connect wxobject, :close_window, [callback: fn(_, _)-> send my_pid, :destroy end]
    end
  end

  defp divide_options(options), do: divide_options(options, [], [])
  defp divide_options([], pre, post), do: {pre, post}
  defp divide_options([{:position, {x, y}}|tail], pre, post), do: divide_options(tail, [{:pos, {x, y}}|pre], post)
  defp divide_options([{:size, {w, h}}|tail], pre, post), do: divide_options(tail, [{:size, {w, h}}|pre], post)
  defp divide_options([{:react, events}|tail], pre, post), do: divide_options(tail, pre, [{:react, events}|post])
  defp divide_options([{:pid, _}|tail], pre, post), do: divide_options(tail, pre, post)
  defp divide_options([{:children_pid, _}|tail], pre, post), do: divide_options(tail, pre, post)
  defp divide_options([{:menu_bar, _}|tail], pre, post), do: divide_options(tail, pre, post)
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

  defp compile_options(_data, []), do: nil
  defp compile_options(data, [head|tail]) do
    compile_option data, head
    compile_options data, tail
  end

  defp compile_option(data, {:react, events}), do: Event.react(data, events)
  defp compile_option(_data, option), do: raise {:uknown_option, option}

end
