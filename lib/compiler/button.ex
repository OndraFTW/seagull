defmodule Compiler.Button do
  
  require Constants

  def compile(id, options, parent, pid) do
    {pre, post}=divide_options options
    wxitem = :wxButton.new parent, -1, pre
    compile_options(wxitem, id, post, pid)
    [{id, [type: :button, wxobject: wxitem]}]
  end

  defp divide_options(options), do: divide_options options, [], []
  defp divide_options([], pre, post), do: {pre, post}
  defp divide_options([{:label, label}|tail], pre, post), do: divide_options tail, [{:label, label}|pre], post
  defp divide_options([{:disabled, true}|tail], pre, post), do: divide_options tail, pre, [:disabled|post]
  defp divide_options([{:default, true}|tail], pre, post), do: divide_options tail, pre, [:default|post]
  defp divide_options([{:position, {w, h}}|tail], pre, post), do: divide_options tail, [{:pos, {w, h}}|pre], post
  defp divide_options([{:size, {w, h}}|tail], pre, post), do: divide_options tail, [{:size, {w, h}}|pre], post
  defp divide_options([{:react, events}|tail], pre, post), do: divide_options tail, pre, [{:react, events}|post]
  defp divide_options([{:align, style}|tail], pre, post) do
    s=case style do
      :top->Constants.wxBU_TOP
      :bottom->Constants.wxBU_BOTTOM
      :right->Constants.wxBU_RIGHT
      :left->Constants.wxBU_LEFT
    end
    divide_options tail, [{:style, s}|pre], post
  end
  defp divide_options([{:style, style}|tail], pre, post) do
    s=case style do
      :exact_fit->Constants.wxBU_EXACTFIT
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
  defp button_react(button, id, [:clicked|tail], pid) do
    my_pid=self
    :wxEvtHandler.connect button, :command_button_clicked, [{:callback, fn(_, _)-> pid<-{my_pid, id, :clicked} end}]
    button_react button, id, tail, pid
  end

end
