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

end
