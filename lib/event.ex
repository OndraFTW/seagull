defmodule Event do
  
  def translate(_id, {:wx_ref, menu_ref, :wxMenu, _}, _data, {:wxMenu, :menu_open}, window) do
    menu=get_widget_by_wx_ref menu_ref, window
    pid=Keyword.get menu, :pid
    id=Keyword.get menu, :id
    pid<-[self, id, :open]
    true
  end
  def translate(_id, {:wx_ref, menu_ref, :wxMenu, _}, _data, {:wxMenu, :menu_close}, window) do
    menu=get_widget_by_wx_ref menu_ref, window
    pid=Keyword.get menu, :pid
    id=Keyword.get menu, :id
    pid<-[self, id, :close]
    true
  end
  def translate(_id, {:wx_ref, menu_ref, :wxMenu, _}, _data, {:wxMenu, :menu_highlight}, window) do
    menu=get_widget_by_wx_ref menu_ref, window
    pid=Keyword.get menu, :pid
    id=Keyword.get menu, :id
    pid<-[self, id, :highlight]
    true
  end
  def translate(_id, _object, _data, _event, _window) do
    false
  end

  defp get_widget_by_wx_ref(ref, []) do
    raise {:widget_not_found, ref}
  end
  defp get_widget_by_wx_ref(ref, [{_id, widget}|tail]) do
    {:wx_ref, wx_ref, _, _}=Keyword.get widget, :wxobject
    if wx_ref==ref, do: widget, else: get_widget_by_wx_ref(ref, tail)
  end

end
