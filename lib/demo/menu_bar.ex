defmodule Demo.MenuBar do
  import Seagull
  import Widget

  def start() do
    mb=menu_bar id: :menu_bar, react: [:select] do
      menu "File", id: :file_menu, react: [:open, :close, :highlight] do
        menu_item "First", id: :first_item
        menu_item "Second", id: :second_item
        menu_item "Third", id: :third_item
        menu_item "Fourth", id: :fourth_item
        menu "Submenu", id: :submenu, react: [:open, :close, :highlight] do
          menu_item "Fifth", id: :fifth_item
          menu_item "Sixth", id: :sixth_item
        end
      end
      menu "Help", id: :help_menu, react: [:open, :close, :highlight]
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
            send pid, :destroy
            continue=false
        end
        from widget: :file_menu do
          :open->IO.puts "Menu File opened."
          :close->IO.puts "Menu File closed."
          :highlight, id->IO.puts "Menu File highlight: #{id}."
        end
        from widget: :submenu do
          :open->IO.puts "Submenu opened."
          :close->IO.puts "Submenu closed."
          :highlight, id->IO.puts "Submenu highlight: #{id}."
        end
        from widget: :help_menu do
          :open->IO.puts "Menu Help opened."
          :close->IO.puts "Menu Help closed."
          :highlight, id->IO.puts "Menu Help highlight: #{id}."
        end
        from widget: :menu_bar do
          :select, id->IO.puts "Menu bar selected: #{id}."
        end
      end
    end
    if continue, do: reaction pid
  end

end
