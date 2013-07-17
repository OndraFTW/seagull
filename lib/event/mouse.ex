defmodule Event.Mouse do

  @events [
    mouse_left_down: :left_down,
    mouse_right_down: :right_down,
    mouse_middle_down: :middle_down,
    mouse_left_up: :left_up,
    mouse_right_up: :right_up,
    mouse_middle_up: :middle_up,
    mouse_left_double_click: :left_dclick,
    mouse_right_double_click: :right_dclick,
    mouse_middle_double_click: :middle_dclick,
    mouse_wheel: :mousewheel,
    mouse_enter: :enter_window,
    mouse_leave: :leave_window,
    mouse_move: :motion
  ]

  def get_events() do
    @events
  end

  lc {sg, wx} inlist @events do
    def react(data, unquote(sg)) do
      :wxEvtHandler.connect Keyword.get(data, :wxobject), unquote(wx), [userData: {Keyword.get(data, :type), Keyword.get(data, :id)}]
      true
    end
  end
  def react(_data, _event), do: false

  lc {sg, wx} inlist @events do
    def dont_react(data, unquote(sg)) do
      :wxEvtHandler.disconnect Keyword.get(data, :wxobject), unquote(wx)
      true
    end
  end
  def dont_react(_data, _event), do: false

  lc {sg, wx} inlist Keyword.delete(@events, :mouse_wheel) do
    def translate(_wxid, _wxobject, id, {_, unquote(wx), x, y, _, _, _, _, _, _, _, _, _, _}, window) do
      widget=Keyword.get window, id
      pid=Keyword.get widget, :pid
      pid<-[self, id, unquote(sg), {x, y}]
      true
    end
  end
  def translate(_wxid, _wxobject, id, {_, :mousewheel, x, y, _, _, _, _, _, _, _, delta, _, _}, window) do
    widget=Keyword.get window, id
    pid=Keyword.get widget, :pid
    pid<-[self, id, :mouse_wheel, {x, y}, if delta>0, do: :up, else: :down]
    true
  end
  def translate(_wxid, _wxobject, _id, _event, _window) do
    false
  end

end
