defmodule Event.Menu do

  @events [
      open: :menu_open,
      close: :menu_close,
      highlight: :menu_highlight
    ]

  def get_events() do
    @events
  end

  lc {sg, wx} inlist @events do
    def react(data, unquote(sg)) do
      :wxEvtHandler.connect Keyword.get(data, :wxobject), unquote(wx), [userData: {:menu, Keyword.get(data, :id)}]
      true
    end
  end

  def react(_button, _id, _event, _pid), do: false

  def translate(_wxid, _wxobject, id, {:wxMenu, :menu_open}, window) do
    menu=Keyword.get window, id
    pid=Keyword.get menu, :pid
    id=Keyword.get menu, :id
    pid<-[self, id, :open]
    true
  end
  def translate(_wxid, _wxobject, id, {:wxMenu, :menu_close}, window) do
    menu=Keyword.get window, id
    pid=Keyword.get menu, :pid
    id=Keyword.get menu, :id
    pid<-[self, id, :close]
    true
  end
  def translate(_wxid, _wxobject, id, {:wxMenu, :menu_highlight}, window) do
    menu=Keyword.get window, id
    pid=Keyword.get menu, :pid
    id=Keyword.get menu, :id
    pid<-[self, id, :highlight]
    true
  end
  def translate(_wx_id, _object, _id, _event, _window) do
    false
  end


end
