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
      :wxEvtHandler.connect Keyword.get(data, :wxobject), unquote(wx)
      true
    end
  end

  def react(_button, _id, _event, _pid), do: false

end
