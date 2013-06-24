defmodule Event.Mouse do

  #left_down | left_up | middle_down | middle_up | right_down | right_up | motion | enter_window | leave_window | left_dclick | middle_dclick | right_dclick | mousewheel

  def react(object, id, :mouse_left_down, pid) do
    my_pid=self
    :wxEvtHandler.connect object, :left_down, [{:callback, fn(_, e)->
        pid<-[my_pid, id, :mouse_left_down, :wxMouseEvent.getPosition(e)]
      end}]
    true
  end
  def react(object, id, :mouse_right_down, pid) do
    my_pid=self
    :wxEvtHandler.connect object, :right_down, [{:callback, fn(_, e)->
        pid<-[my_pid, id, :mouse_right_down, :wxMouseEvent.getPosition(e)]
      end}]
    true
  end
  def react(object, id, :mouse_middle_down, pid) do
    my_pid=self
    :wxEvtHandler.connect object, :middle_down, [{:callback, fn(_, e)->
        pid<-[my_pid, id, :mouse_middle_down, :wxMouseEvent.getPosition(e)]
      end}]
    true
  end
  def react(object, id, :mouse_left_up, pid) do
    my_pid=self
    :wxEvtHandler.connect object, :left_up, [{:callback, fn(_, e)->
        pid<-[my_pid, id, :mouse_left_up, :wxMouseEvent.getPosition(e)]
      end}]
    true
  end
  def react(object, id, :mouse_right_up, pid) do
    my_pid=self
    :wxEvtHandler.connect object, :right_up, [{:callback, fn(_, e)->
        pid<-[my_pid, id, :mouse_right_up, :wxMouseEvent.getPosition(e)]
      end}]
    true
  end
  def react(object, id, :mouse_middle_up, pid) do
    my_pid=self
    :wxEvtHandler.connect object, :middle_up, [{:callback, fn(_, e)->
        pid<-[my_pid, id, :mouse_middle_up, :wxMouseEvent.getPosition(e)]
      end}]
    true
  end
  def react(object, id, :mouse_enter, pid) do
    my_pid=self
    :wxEvtHandler.connect object, :enter_window, [{:callback, fn(_, e)->
        pid<-[my_pid, id, :mouse_enter, :wxMouseEvent.getPosition(e)]
      end}]
    true
  end
  def react(object, id, :mouse_leave, pid) do
    my_pid=self
    :wxEvtHandler.connect object, :leave_window, [{:callback, fn(_, e)->
        pid<-[my_pid, id, :mouse_leave, :wxMouseEvent.getPosition(e)]
      end}]
    true
  end
  def react(object, id, :mouse_move, pid) do
    my_pid=self
    :wxEvtHandler.connect object, :motion, [{:callback, fn(_, e)->
        pid<-[my_pid, id, :mouse_move, :wxMouseEvent.getPosition(e)]
      end}]
    true
  end
  def react(object, id, :mouse_wheel, pid) do
    my_pid=self
    :wxEvtHandler.connect object, :mousewheel, [{:callback, fn(_, e)->
        pid<-[my_pid, id, :mouse_wheel, if :wxMouseEvent.getWheelRotation(e)>0, do: :up, else: :down]
      end}]
    true
  end
  def react(object, id, :mouse_left_double_click, pid) do
    my_pid=self
    :wxEvtHandler.connect object, :left_dclick, [{:callback, fn(_, e)->
        pid<-[my_pid, id, :mouse_left_double_click, :wxMouseEvent.getPosition(e)]
      end}]
    true
  end
  def react(object, id, :mouse_right_double_click, pid) do
    my_pid=self
    :wxEvtHandler.connect object, :right_dclick, [{:callback, fn(_, e)->
        pid<-[my_pid, id, :mouse_right_double_click, :wxMouseEvent.getPosition(e)]
      end}]
    true
  end
  def react(object, id, :mouse_middle_double_click, pid) do
    my_pid=self
    :wxEvtHandler.connect object, :middle_dclick, [{:callback, fn(_, e)->
        pid<-[my_pid, id, :mouse_middle_double_click, :wxMouseEvent.getPosition(e)]
      end}]
    true
  end
  def react(_button, _id, _event, _pid), do: false

end
