defmodule Sigui do

  def get(pid, id, func, options//[]) do
    pid <- {self(), id, func, options}
    receive do
      {^pid, ^id, ^func, result}->result
    end
  end

  def rec() do
    receive do
      a->a
    end
  end

end
