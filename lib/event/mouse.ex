defmodule Event.Mouse do

  #left_down | left_up | middle_down | middle_up | right_down | right_up | motion | enter_window | leave_window | left_dclick | middle_dclick | right_dclick | mousewheel

  def react(object, id, :mouse_left_down, pid) do
    my_pid=self
    :wxEvtHandler.connect object, :left_down, [{:callback, fn(_, _)-> pid<-{my_pid, id, :mouse_left_down} end}]
    true
  end
  def react(object, id, :mouse_right_down, pid) do
    my_pid=self
    :wxEvtHandler.connect object, :right_down, [{:callback, fn(_, _)-> pid<-{my_pid, id, :mouse_right_down} end}]
    true
  end
  def react(object, id, :mouse_middle_down, pid) do
    my_pid=self
    :wxEvtHandler.connect object, :middle_down, [{:callback, fn(_, _)-> pid<-{my_pid, id, :mouse_middle_down} end}]
    true
  end
  def react(_button, _id, _event, _pid), do: false

end
