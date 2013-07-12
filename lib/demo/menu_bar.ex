defmodule Demo.MenuBar do
  import Seagull
  import Widget

  def start() do
    mb=menu_bar do
      menu "File"
    end
    f=frame :frame, "A", menu_bar: mb do
      button :_
    end
    WindowProcess.spawn f
  end 
end
