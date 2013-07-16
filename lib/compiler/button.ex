defmodule Compiler.Button do
  
  require Constant
  require Bitwise

  def compile(id, options, data) do
    if id==:_, do: id=Compiler.random_id
    {pre, post}=divide_options options
    pre=Compiler.fuse_styles pre
    parent=Keyword.get data, :wxparent
    pid=Keyword.get data, :pid
    data=Keyword.delete data, :pid
    my_pid=Keyword.get options, :pid, pid
    wxitem = :wxButton.new parent, Constant.wxID_ANY, pre
    data=[type: :button, wxobject: wxitem, id: id, pid: my_pid]++data
    compile_options(data, post)
    [{id, data}]
  end

  defp divide_options(options), do: divide_options options, [], []
  defp divide_options([], pre, post), do: {pre, post}
  defp divide_options([{:label, label}|tail], pre, post) when is_list(label), do: divide_options tail, [{:label, label}|pre], post
  defp divide_options([{:label, label}|tail], pre, post), do: divide_options tail, [{:label, binary_to_list(label)}|pre], post
  defp divide_options([{:disabled, value}|tail], pre, post), do: if value, do: divide_options(tail, pre, [:disabled|post]), else: divide_options(tail, pre, post)
  defp divide_options([{:default, value}|tail], pre, post), do: if value, do: divide_options(tail, pre, [:default|post]), else: divide_options(tail, pre, post)
  defp divide_options([{:position, {w, h}}|tail], pre, post), do: divide_options tail, [{:pos, {w, h}}|pre], post
  defp divide_options([{:size, {w, h}}|tail], pre, post), do: divide_options tail, [{:size, {w, h}}|pre], post
  defp divide_options([{:react, events}|tail], pre, post), do: divide_options tail, pre, [{:react, events}|post]
  defp divide_options([{:exact_fit, value}|tail], pre, post), do: if value, do: divide_options(tail, [{:style, Constant.wxBU_EXACTFIT}|pre], post), else: divide_options(tail, pre, post)
  defp divide_options([{:no_border, value}|tail], pre, post), do: if value, do: divide_options(tail, [{:style, Constant.wxNO_BORDER}|pre], post), else: divide_options(tail, pre, post)
  defp divide_options([{:pid, _}|tail], pre, post), do: divide_options tail, pre, post
  defp divide_options([{:children_pid, _}|tail], pre, post), do: divide_options tail, pre, post
  defp divide_options([{:label_align, style}|tail], pre, post) do
    s=case style do
      :top->Constant.wxBU_TOP
      :bottom->Constant.wxBU_BOTTOM
      :right->Constant.wxBU_RIGHT
      :left->Constant.wxBU_LEFT
      :top_left->Bitwise.bor Constant.wxBU_TOP, Constant.wxBU_LEFT
      :top_right->Bitwise.bor Constant.wxBU_TOP, Constant.wxBU_RIGHT
      :bottom_left->Bitwise.bor Constant.wxBU_BOTTOM, Constant.wxBU_LEFT
      :bottom_right->Bitwise.bor Constant.wxBU_BOTTOM, Constant.wxBU_RIGHT
    end
    divide_options tail, [{:style, s}|pre], post
  end
  
  defp compile_options(_data, []), do: true
  defp compile_options(data, [head|tail]) do
    compile_option data, head
    compile_options data, tail
  end

  defp compile_option(data, {:react, events}), do: Event.react data, events
  defp compile_option(data, {:label, label}), do: :wxButton.setLabel Keyword.get(data, :wxobject), label
  defp compile_option(data, :disabled), do: :wxButton.disable Keyword.get(data, :wxobject)
  defp compile_option(data, :default), do: :wxButton.setDefault Keyword.get(data, :wxobject)
  defp compile_option(_data, option), do: raise {:uknown_option, option}

end
