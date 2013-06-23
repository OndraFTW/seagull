defmodule Event.Button do

  def react(button, id, :click, pid) do
    my_pid=self
    :wxEvtHandler.connect button, :command_button_clicked, [{:callback, fn(_, _)-> pid<-[my_pid, id, :click] end}]
    true
  end
  def react(_button, _id, _event, _pid), do: false

end
