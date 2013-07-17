defmodule Event do

  @event_groups [
    menu: [Event.Menu],
    button: [Event.Button, Event.Mouse],
    text_box: [Event.TextBox, Event.Mouse],
    frame: [Event.Frame, Event.TopLevelWindow, Event.Mouse]
  ]

  def react(_data, []), do: true
  def react(data, [event|tail]) do
    if Event.react(Keyword.get(data, :type), data, event) do
      react data, tail
    else
      raise {:uknown_event, event}
    end
  end

  def react(data, event) do
    if not Event.react(Keyword.get(data, :type), data, event) do
      raise {:uknown_event, event}
    end
  end

  lc {widget, event_groups} inlist @event_groups do
    def react(unquote(widget), data, event) do
      Enum.any?(unquote(event_groups), fn(group)-> group.react(data, event) end)
    end
  end

  def dont_react(_data, []), do: true
  def dont_react(data, [head|tail]) do
    dont_react data, head
    dont_react data, tail
  end
  def dont_react(data, event) do
    if not dont_react(Keyword.get(data, :type), data, event) do
      raise {:uknown_event, event}
    end
  end

  lc {widget, event_groups} inlist @event_groups do
    def dont_react(unquote(widget), data, event) do
      Enum.any?(unquote(event_groups), fn(group)-> group.dont_react(data, event) end)
    end
  end

  lc {widget, event_groups} inlist @event_groups do
    def translate(wxid, wxobject, {unquote(widget), id}, event, window) do
      if not Enum.any?(unquote(event_groups), fn(group)-> group.translate(wxid, wxobject, id, event, window) end) do
        raise {:uknown_event, id, event}
      end
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
