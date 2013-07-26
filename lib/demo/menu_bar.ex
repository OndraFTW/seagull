defmodule Demo.MenuBar do
  import Seagull
  import Widget

  def start() do
    mb=menu_bar do
      menu "File", id: :file_menu, react: [:open, :close, :highlight, :select] do
        menu_item "First"
        menu_item "Second"
        menu_item "Third"
        menu_item "Fourth"
        menu "Submenu" do
          menu_item "Fifth"
          menu_item "Sixth"
        end
      end
    end

    f=frame id: :frame, menu_bar: mb, react: [:close]
    
    pid=WindowProcess.spawn f

    reaction pid

  end

  defp reaction(pid) do
    continue=true
    receive_event do
      from pid: ^pid do
        from widget: :frame do
          :close->
            pid<-:destroy
            continue=false
        end
        from widget: :file_menu do
          :open->IO.puts "Menu File opened."
          :close->IO.puts "Menu File closed."
          :highlight->IO.puts "Menu highlight."
          :select->IO.puts "Menu select."
        end
      end
    end
    if continue, do: reaction pid
  end

end
