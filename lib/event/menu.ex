defmodule Event.Menu do
  require Event
  
  @events [
      open: :menu_open,
      close: :menu_close,
      highlight: :menu_highlight
    ]

  def get_events() do
    @events
  end

  Event.generate_function_react()
  Event.generate_function_dont_react()

  lc {sg, _wx} inlist Keyword.delete(@events, :highlight) do
    def translate(_wxid, _wxobject, id, unquote(sg), _event, window) do
      widget=Keyword.get window, id
      pid=Keyword.get widget, :pid
      send pid, [self, id, unquote(sg)]
      true
    end
  end
  def translate(wxid, _wxobject, id, :highlight, _event, window) do
    if wxid != -1 do
      item=Event.get_widget_by_wx_ref window, wxid
      if item == nil do
        item=get_submenu_by_supermenu_item_wx_ref window, wxid
      end
      item_id=Keyword.get item, :id
      widget=Keyword.get window, id
      pid=Keyword.get widget, :pid
      send pid, [self, id, :highlight, item_id]
      true
    else
      true
    end
  end
  def translate(_wxid, _wxobject, _id, _event_type, _event, _window) do
    false
  end

  def get_submenu_by_supermenu_item_wx_ref([], ref) do
    raise {:uknown_widget, ref}
  end
  def get_submenu_by_supermenu_item_wx_ref([{_id, head}|tail], ref) do
    wxitem=Keyword.get head, :supermenu_item, nil
    if wxitem == nil do
      get_submenu_by_supermenu_item_wx_ref tail, ref
    else
      {:wx_ref, wx_ref, _, _}=wxitem
      if wx_ref == ref do
        head
      else
        get_submenu_by_supermenu_item_wx_ref tail, ref
      end
    end
  end

end
