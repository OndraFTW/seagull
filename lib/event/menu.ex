defmodule Event.Menu do

  @events [
      open: :menu_open,
      close: :menu_close,
      highlight: :menu_highlight,
      select: :command_menu_selected
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

  lc {sg, wx} inlist Keyword.delete(@events, :highlight) do
    def translate(_wxid, _wxobject, id, {_, unquote(wx)}, window) do
      widget=Keyword.get window, id
      pid=Keyword.get widget, :pid
      pid<-[self, id, unquote(sg)]
      true
    end
  end
  def translate(wxid, _wxobject, id, {_, :menu_highlight}, window) do
    if wxid != -1 do
      item=Event.get_widget_by_wx_ref window, wxid
      if item == nil do
        item=get_submenu_by_supermenu_item_wx_ref window, wxid
      end
      item_id=Keyword.get item, :id
      widget=Keyword.get window, id
      pid=Keyword.get widget, :pid
      pid<-[self, id, :highlight, item_id]
      true
    else
      true
    end
  end
  def translate(_wxid, _wxobject, _id, _event, _window) do
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
