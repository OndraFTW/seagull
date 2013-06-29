defmodule Compiler.Button do
  
  require Constant

  def compile(id, options, data) do
    if id==:_, do: id=Compiler.random_id
    {pre, post}=divide_options options
    parent=Keyword.get data, :wxparent
    pid=Keyword.get data, :pid
    my_pid=Keyword.get options, :pid, pid
    wxitem = :wxButton.new parent, Constant.wxID_ANY, pre
    compile_options(wxitem, id, post, my_pid)
    [{id, [type: :button, wxobject: wxitem, id: id, pid: my_pid]++data}]
  end

  defp divide_options(options), do: divide_options options, [], []
  defp divide_options([], pre, post), do: {pre, post}
  defp divide_options([{:label, label}|tail], pre, post) when is_list(label), do: divide_options tail, [{:label, label}|pre], post
  defp divide_options([{:label, label}|tail], pre, post), do: divide_options tail, [{:label, binary_to_list(label)}|pre], post
  defp divide_options([{:disabled, true}|tail], pre, post), do: divide_options tail, pre, [:disabled|post]
  defp divide_options([{:default, true}|tail], pre, post), do: divide_options tail, pre, [:default|post]
  defp divide_options([{:position, {w, h}}|tail], pre, post), do: divide_options tail, [{:pos, {w, h}}|pre], post
  defp divide_options([{:size, {w, h}}|tail], pre, post), do: divide_options tail, [{:size, {w, h}}|pre], post
  defp divide_options([{:react, events}|tail], pre, post), do: divide_options tail, pre, [{:react, events}|post]
  defp divide_options([{:exact_fit, true}|tail], pre, post), do: divide_options tail, [{:style, Constant.wxBU_EXACTFIT}|pre], post
  defp divide_options([{:no_border, true}|tail], pre, post), do: divide_options tail, [{:style, Constant.wxNO_BORDER}|pre], post
  defp divide_options([{:pid, _}|tail], pre, post), do: divide_options tail, pre, post
  defp divide_options([{:children_pid, _}|tail], pre, post), do: divide_options tail, pre, post
  defp divide_options([{:label_align, style}|tail], pre, post) do
    s=case style do
      :top->Constant.wxBU_TOP
      :bottom->Constant.wxBU_BOTTOM
      :right->Constant.wxBU_RIGHT
      :left->Constant.wxBU_LEFT
    end
    divide_options tail, [{:style, s}|pre], post
  end
  
  defp compile_options(_button, _id, [], _pid), do: true
  defp compile_options(button, id, [head|tail], pid) do
    compile_option button, id, head, pid
    compile_options button, id, tail, pid
  end

  defp compile_option(button, id, {:react, events}, pid), do: button_react button, id, events, pid
  defp compile_option(button, _id, {:label, label}, _pid), do: :wxButton.setLabel button, label
  defp compile_option(button, _id, :disabled, _pid), do: :wxButton.disable button
  defp compile_option(button, _id, :default, _pid), do: :wxButton.setDefault button

  defp button_react(_button, _id, [], _pid), do: true
  defp button_react(button, id, [event|tail], pid) do
    if Event.Button.react(button, id, event, pid) or Event.Mouse.react(button, id, event, pid) do
      button_react button, id, tail, pid
    else
      raise {:uknown_event, event}
    end
  end

end
