defmodule Demo.MenuBar do
  import Seagull
  import Widget

  def start() do
    mb=menu_bar do
      menu "File" do
        menu_item :_, "First"
        menu_item :_, "Second"
      end
    end

    f=frame :frame, "A", menu_bar: mb do
      button :_
    end
    
    WindowProcess.spawn f
  end 
end
