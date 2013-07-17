defmodule Event.Button do

  @events [
    click: :command_button_clicked
  ]

  def get_events() do
    @events
  end

  lc {sg, wx} inlist @events do
    def react(data, unquote(sg)) do
      :wxEvtHandler.connect Keyword.get(data, :wxobject), unquote(wx), [userData: {:button, Keyword.get(data, :id)}]
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


  lc {sg, wx} inlist @events do
    def translate(_wxid, _wxobject, id, {_, unquote(wx), _, _, _}, window) do
      widget=Keyword.get window, id
      pid=Keyword.get widget, :pid
      pid<-[self, id, unquote(sg)]
      true
    end
  end
  def translate(_wxid, _wxobject, _id, _event, _window) do
    false
  end

end
