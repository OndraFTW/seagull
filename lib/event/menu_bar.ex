defmodule Event.MenuBar do
  require Event

  @events [
      select: :command_menu_selected
    ]

  def get_events() do
    @events
  end

  def react(data, :select) do
    :wxEvtHandler.connect Keyword.get(data, :wxparent), :command_menu_selected, [userData: {Keyword.get(data, :type), Keyword.get(data, :id), :select}]
	true
  end
  def react(_data, _event), do: false
  
  def dont_react(data, :select) do
    :wxEvtHandler.disconnect Keyword.get(data, :wxparent), :command_menu_selected
    true
  end
  def dont_react(_data, _event), do: false

  def translate(wxid, _wxobject, id, :select, _event, window) do
    menu_item=Event.get_widget_by_wx_ref(window, wxid)
    widget=Keyword.get window, id
    pid=Keyword.get widget, :pid
    send pid, [self, id, :select, Keyword.get(menu_item, :id)]
    true
  end
  def translate(_wxid, _wxobject, _id, _event_type, _event, _window) do
    false
  end

end
