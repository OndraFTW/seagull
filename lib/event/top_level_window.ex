defmodule Event.TopLevelWindow do

  def react(frame, id, :create, pid) do
   my_pid=self
   :wxEvtHandler.connect frame, :create, [{:callback, fn(_, _)-> pid<-[my_pid, id, :create] end}]
   true
  end
  def react(frame, id, :destroy, pid) do
   my_pid=self
   :wxEvtHandler.connect frame, :destroy, [{:callback, fn(_, _)-> pid<-[my_pid, id, :destroy] end}]
   true
  end
  def react(frame, id, :maximize, pid) do
   my_pid=self
   :wxEvtHandler.connect frame, :aui_pane_maximize, [{:callback, fn(_, _)-> pid<-[my_pid, id, :maximize] end}]
   true
  end
  def react(frame, id, :minimize, pid) do
   my_pid=self
   :wxEvtHandler.connect frame, :iconize, [{:callback, fn(_, _)-> pid<-[my_pid, id, :minimize] end}]
   true
  end
  def react(_frame, _id, _event, _pid), do: false

end
