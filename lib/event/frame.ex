defmodule Event.Frame do

  def react(frame, id, :close, pid) do
   my_pid=self
   :wxEvtHandler.connect frame, :close_window, [{:callback, fn(_, _)-> pid<-[my_pid, id, :close] end}]
   true
  end
  def react(_frame, _id, _event, _pid), do: false

end
