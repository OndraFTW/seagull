defmodule WindowProcess do
  
  @doc"Starts new GUI, which sends events to process pid."
  def start(gui, pid//self()) do
    spawn WindowProcess, :gui_process, [gui, pid]
  end

  @doc"GUI process."
  def gui_process(frame, pid) do
    :wx.new
    #compile records into wxObjects
    window=Compiler.compile(frame, pid)
    [{_id, data}|_tail]=window
    :wxFrame.show Keyword.get(data, :wxobject)
    rec(window, pid)
    :wx.destroy
  end

  # Receives message, sends response and calls itself.
  defp rec(window, pid) do
    receive do
      :destroy->
        nil
      {pid, id, function, params}->
        send window, pid, id, function, params
        rec window, pid
      a-> 
        IO.inspect a
        rec window, pid
    end
  end

  # Send response to message func for object id with params in to pid.
  defp send(window, pid, id, func, params) do
    object=Keyword.get window, id
    pid<-{self(), id, func, respond(Keyword.get(object, :type), object, func, params)}
  end

  # Returns response to message func for object id with params in to pid.
  defp respond(:button, object, func, params), do: WindowProcess.Button.respond object, func, params
  defp respond(:frame, object, func, params), do: WindowProcess.Frame.respond object, func, params
  defp respond(:box, object, func, params), do: WindowProcess.Box.respond object, func, params
  defp respond(type, _object, _func, _params), do: raise {:uknown_type, type}

end
