defmodule Event.TopLevelWindow do

  @events [
      close: :close_window,
      create: :create,
      destroy: :destroy,
      maximize: :aui_pane_maximize,
      minimize: :iconize
    ]

  def get_events() do
    @events
  end

  Event.generate_function_react()
  Event.generate_function_dont_react()

  lc {sg, wx} inlist @events do
    def translate(_wxid, _wxobject, id, {_, unquote(wx)}, window) do
      widget=Keyword.get window, id
      pid=Keyword.get widget, :pid
      send pid, [self, id, unquote(sg)]
      true
    end
  end
  def translate(_wxid, _wxobject, _id, _event, _window) do
    false
  end

end
