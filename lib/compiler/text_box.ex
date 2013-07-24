defmodule Compiler.TextBox do
  
  require Constant

  def compile({id}, options, [], data) do
    if id==:_, do: id=Compiler.random_id
    {pre, post}=divide_options options
    pre=Compiler.fuse_styles [{:style, 1024}|pre]
    parent=Keyword.get data, :wxparent
    pid=Keyword.get data, :pid
    data=Keyword.delete data, :pid
    my_pid=Keyword.get options, :pid, pid
    wxitem = :wxTextCtrl.new parent, Constant.wxID_ANY, pre
    data=[type: :text_box, wxobject: wxitem, id: id, pid: my_pid]++data
    compile_options(data, post)
    [{id, data}]
  end

  defp divide_options(options), do: divide_options options, [], []
  defp divide_options([], pre, post), do: {pre, post}
  defp divide_options([{:value, value}|tail], pre, post), do: divide_options tail, [{:value, binary_to_list(value)}|pre], post
  defp divide_options([{:position, {x, y}}|tail], pre, post), do: divide_options tail, [{:pos, {x, y}}|pre], post
  defp divide_options([{:size, {w, h}}|tail], pre, post), do: divide_options tail, [{:size, {w, h}}|pre], post
  defp divide_options([{:multiline, value}|tail], pre, post), do: if value, do: divide_options(tail, [{:style, Constant.wxTE_MULTILINE}|pre], post), else: divide_options(tail, pre, post)
  defp divide_options([{:readonly, value}|tail], pre, post), do: if value, do: divide_options(tail, [{:style, Constant.wxTE_READONLY}|pre], post), else: divide_options(tail, pre, post)
  defp divide_options([{:react, events}|tail], pre, post), do: divide_options tail, pre, [{:react, events}|post]
  defp divide_options([{:text_align, value}|tail], pre, post) do
    v=case value do
      :right->Constant.wxTE_RIGHT
      :left->Constant.wxTE_LEFT
      :center->Constant.wxTE_CENTER
      :centre->Constant.wxTE_CENTRE
    end
    divide_options tail, [{:style, v}|pre], post
  end
  defp divide_options([{:wrap, value}|tail], pre, post) do
    v=case value do
      :dont->Constant.wxTE_DONTWRAP
      :character->Constant.wxTE_CHARWRAP
      :word->Constant.wxTE_WORDWRAP
      :best->Constant.wxTE_BESTWRAP
    end
    divide_options tail, [{:style, v}|pre], post
  end
  
  defp compile_options(_data, []), do: true
  defp compile_options(data, [head|tail]) do
    compile_option data, head
    compile_options data, tail
  end

  defp compile_option(data, {:react, events}), do: Event.react data, events
  defp compile_option(_data, option), do: raise {:uknowm_option, option}

end
