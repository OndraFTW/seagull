defmodule WindowProcess do
  
  @doc"Spawns new GUI, which sends events to process pid."
  def spawn_gui(gui), do: spawn_gui(gui, [])
  def spawn_gui(gui, options) do
    pid=Keyword.get options, :default_pid, self
    spawn WindowProcess, :gui_process, [gui, pid]
  end

  @doc"GUI process."
  def gui_process(tree, pid) do
    :wx.new
    #compile records into wxObjects
    compiled=Compiler.compile(tree, pid)
    [{_id, data}|_tail]=compiled
    :wxFrame.show Keyword.get(data, :wxobject)
    rec pid, {compiled, tree}
    :wx.destroy
  end

  # Receives message, sends response and calls itself.
  defp rec(pid, window) do
    receive do
      :destroy->
        nil
      {pid, id, function, params}->
        window=respond window, pid, id, function, params
        rec pid, window
      {:wx, id, object, data, event}->
        Event.translate id, object, data, event, elem(window, 0)
        rec pid, window
      a-> 
        IO.inspect a
        rec pid, window
    end
  end

  # Send response to message func for object id with params in to pid.
  defp respond(window, pid, id, func, params) do
    {compiled, _tree}=window
    object=Keyword.get(compiled, id, nil)
    if object==nil, do: raise {:uknown_object, id}
    object=[{:window, window}|object]
    response=get_response(Keyword.get(object, :type), object, func, params)
    response=case response do
      {:response_and_window, response, window}->response
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
    defp get_response(unquote(type), object, func, params), do: unquote(class).respond(object, func, params)
  end
  defp get_response(type, _object, _func, _params), do: raise {:uknown_type, type}

end
