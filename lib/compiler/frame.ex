defmodule Compiler.Frame do
  import Constant

  def compile(id, title, options, children, data) do
    if is_binary(title), do: title=binary_to_list title
    {pre, post}=divide_options options
    pid=Keyword.get data, :pid
    parent=Keyword.get data, :wxparent
    wxitem = :wxFrame.new parent, Constant.wxID_ANY, title, pre
    compile_options(wxitem, id, post, pid)
    children=Compiler.compile_children children, [wxparent: wxitem, parent: id, pid: pid], []
    [{id, [type: :frame, wxobject: wxitem, id: id]++data}|children]
  end

  defp divide_options(options), do: divide_options options, [], []
  defp divide_options([], pre, post), do: {pre, post}
  defp divide_options([{:position, {x, y}}|tail], pre, post), do: divide_options tail, [{:pos, {x, y}}|pre], post
  defp divide_options([{:size, {w, h}}|tail], pre, post), do: divide_options tail, [{:size, {w, h}}|pre], post
  defp divide_options([{:react, events}|tail], pre, post), do: divide_options tail, pre, [{:react, events}|post]
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
    if Event.Frame.react(frame, id, event, pid) or Event.Mouse.react(frame, id, event, pid) do
      react frame, id, tail, pid
    end
  end

end
