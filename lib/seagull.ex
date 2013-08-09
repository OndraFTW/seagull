defmodule Seagull do

  @moduledoc"""
    Provides basic functions for working with GUI.
  """

  @doc"Sends message to GUI and returns response to this message."
  def send(pid, id, func, options//[]) do
    pid <- {self(), id, func, options}
    receive do
      {^pid, ^id, ^func, result}->result
    end
  end

  defp prepend_get(s), do: 'get_'++s

  @doc"Gets value of property of object id in GUI pid"
  def get(pid, id, property, options//[]) do
    send pid, id, (property |> atom_to_list |> prepend_get |> list_to_atom), options
  end

  defp prepend_set(s), do: 'set_'++s

  @doc"Sets value of property of object id in GUI pid"
  def set(pid, id, property, options//[]) do
    send pid, id, (property |> atom_to_list |> prepend_set |> list_to_atom), options
  end

  @doc"Receives one message and returns it."
  def rec() do
    receive do
      a->a
    end
  end

  def pid_to_binary(pid) do
    pid |> pid_to_list |> list_to_binary
  end

  #macro receive_event

  defmacro receive_event(block) do
    {:receive, [], [[do: {:"->", [], Enum.reverse(define_lines(block))}]]}
  end

  defp define_lines([do: {:__block__, _, block}]) do
    Enum.reduce block, [], define_line(&1, &2)
  end
  defp define_lines([do: insides]) do
    define_line insides, []
  end

  defp define_line({:from, _, [[pid: pid, widget: widget], [do: {:"->", _, list}]]}, acc) do
        add_pid_and_widget(list, [pid: pid, widget: widget])++acc
  end
  defp define_line({:from, _, [[pid: pid, widget: widget, do: {:"->", _, list}]]}, acc) do
        add_pid_and_widget(list, [pid: pid, widget: widget])++acc
  end
  defp define_line({:from, _, [[pid: pid], [do: {:from, _, [[widget: widget], [do: {:"->", _, list}]]}]]}, acc) do
        add_pid_and_widget(list, [pid: pid, widget: widget])++acc
  end
  defp define_line({:from, _, [[pid: pid], [do: {:__block__, _, block2}]]}, acc) do
    Enum.reduce(block2, [], fn
      ({:from, _, [[widget: widget], [do: {:"->", _, list}]]}, acc2)->
        add_pid_and_widget(list, [pid: pid, widget: widget])++acc2
      ({:from, _, [[widget: widget, do: {:"->", _, list}]]}, acc2)->
        add_pid_and_widget(list, [pid: pid, widget: widget])++acc2
    end) ++ acc
  end
  defp define_line({:from, _, [[pid: pid, do: {:from, _, [[widget: widget], [do: {:"->", _, list}]]}]]}, acc) do
        add_pid_and_widget(list, [pid: pid, widget: widget])++acc
  end
  defp define_line({:from, _, [[pid: pid, do: {:__block__, _, block2}]]}, acc) do
    Enum.reduce(block2, [], fn
      ({:from, _, [[widget: widget], [do: {:"->", _, list}]]}, acc2)->
        add_pid_and_widget(list, [pid: pid, widget: widget])++acc2
      ({:from, _, [[widget: widget, do: {:"->", _, list}]]}, acc2)->
        add_pid_and_widget(list, [pid: pid, widget: widget])++acc2
    end) ++ acc
  end
  defp define_line({:message, _, [[do: {:"->", _, list}]]}, acc) do
    list++acc
  end

  defp add_pid_and_widget(list, data), do: add_pid_and_widget(list, data, [])
  defp add_pid_and_widget([], _data, result), do: result
  defp add_pid_and_widget([{pre, metadata, post}|tail], data, result) do
    add_pid_and_widget tail, data, [{[[Keyword.get(data, :pid), Keyword.get(data, :widget)|pre]], metadata, post}|result]
  end

end
