defmodule WindowProcess do
  
  @doc"Spawns new GUI, which sends events to process pid."
  def spawn(gui, pid//self()) do
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
        window=send window, pid, id, function, params
        rec window, pid
      {:wx, id, object, data, event}->
        Event.translate id, object, data, event, window
        rec window, pid
      a-> 
        IO.inspect a
        rec window, pid
    end
  end

  # Send response to message func for object id with params in to pid.
  defp send(window, pid, id, func, params) do
    object=Keyword.get(window, id, nil)
    if object==nil, do: raise {:uknown_object, id}
    object=[{:window, window}|object]
    response=respond(Keyword.get(object, :type), object, func, params)
    response=case response do
      {:response_window, response, window}->response
      response->response
    end
    send pid, {self(), id, func, response}
    window
  end

  @classes [
    button: WindowProcess.Button,
    frame: WindowProcess.Frame,
    box: WindowProcess.Box,
    text_box: WindowProcess.TextBox
  ]

  # Returns response to message func for object id with params in to pid.
  lc {type, class} inlist @classes do
    defp respond(unquote(type), object, func, params), do: unquote(class).respond(object, func, params)
  end
  defp respond(type, _object, _func, _params), do: raise {:uknown_type, type}

end
