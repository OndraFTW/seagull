defmodule Sigui do

  def send(pid, id, func, options//[]) do
    pid <- {self(), id, func, options}
    receive do
      {^pid, ^id, ^func, result}->result
    end
  end

  defp prepend_get(s), do: 'get_'++s

  def get(pid, id, func, options//[]) do
    send pid, id, (func |> atom_to_list |> prepend_get |> list_to_atom), options
  end

  defp prepend_set(s), do: 'set_'++s

  def set(pid, id, func, options//[]) do
    send pid, id, (func |> atom_to_list |> prepend_set |> list_to_atom), options
  end


  def rec() do
    receive do
      a->a
    end
  end

end
