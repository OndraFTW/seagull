defmodule Event.MenuBar do

  @events [
      select: :command_menu_selected
    ]

  def get_events() do
    @events
  end

  Event.generate_function_react()
  Event.generate_function_dont_react()

  lc {sg, wx} inlist @events do
    def translate(_wxid, _wxobject, id, {_, unquote(wx),_ ,_ ,_}, window) do
      widget=Keyword.get window, id
      pid=Keyword.get widget, :pid
      send pid, [self, id, unquote(sg)]
      true
    end
    def translate(_wxid, _wxobject, _id, _event, _window) do
      false
  	end
  end

end
