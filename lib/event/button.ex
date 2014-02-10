defmodule Event.Button do
  require Event

  @events [
    click: :command_button_clicked
  ]

  def get_events() do
    @events
  end

  Event.generate_function_react()
  Event.generate_function_dont_react()

  lc {sg, wx} inlist @events do
    def translate(_wxid, _wxobject, id, unquote(sg), {_, unquote(wx), _, _, _}, window) do
      widget=Keyword.get window, id
      pid=Keyword.get widget, :pid
      send pid, [self, id, unquote(sg)]
      true
    end
  end
  def translate(_wxid, _wxobject, _id, _event_type, _event, _window) do
    false
  end

end
