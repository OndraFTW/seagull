defmodule Event.TextBox do

  def react(button, id, :update, pid) do
    my_pid=self
    :wxEvtHandler.connect button, :command_text_updated, [{:callback, fn(_, _)-> pid<-[my_pid, id, :update] end}]
    true
  end
  def react(button, id, :enter_pressed, pid) do
    my_pid=self
    :wxEvtHandler.connect button, :command_text_enter, [{:callback, fn(_, _)-> pid<-[my_pid, id, :enter_pressed] end}]
    true
  end
  def react(_button, _id, _event, _pid), do: false

end
