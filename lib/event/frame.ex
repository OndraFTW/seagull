defmodule Event.Frame do
  require Event

  @events []

  def get_events() do
    @events
  end

  Event.generate_function_react()
  Event.generate_function_dont_react()

  for {sg, _wx} <- @events do
    def translate(_wxid, _wxobject, id, unquote(sg), _event, window) do
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
