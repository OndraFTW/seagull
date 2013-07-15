defmodule Event do

  def translate(wx_id, object, {:menu, id}, event, window) do
    if not Event.Menu.translate wx_id, object, id, event, window do
      raise {:uknown_event, event}
    end
  end

  def translate(wx_id, object, {:button, id}, event, window) do
    if not Event.Button.translate wx_id, object, id, event, window do
      raise {:uknown_event, event}
    end
  end

  def translate(wx_id, object, {:text_box, id}, event, window) do
    if not Event.TextBox.translate wx_id, object, id, event, window do
      raise {:uknown_event, event}
    end
  end

  def translate(wx_id, object, {:frame, id}, event, window) do
    if not (Event.TopLevelWindow.translate(wx_id, object, id, event, window) or
           Event.Frame.translate(wx_id, object, id, event, window)) do
      raise {:uknown_event, event}
    end
  end

  def get_widget_by_wx_ref(ref, []) do
    raise {:widget_not_found, ref}
  end
  def get_widget_by_wx_ref(ref, [{_id, widget}|tail]) do
    {:wx_ref, wx_ref, _, _}=Keyword.get widget, :wxobject
    if wx_ref==ref, do: widget, else: get_widget_by_wx_ref(ref, tail)
  end

end
