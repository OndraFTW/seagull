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

  def translate(_wxid, _wxobject, id, {:wxCommand, :command_button_clicked, _, _, _}, window) do
    widget=Keyword.get window, id
    pid=Keyword.get widget, :pid
    pid<-[self, id, :click]
    true
  end

end
