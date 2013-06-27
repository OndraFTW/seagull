defmodule Demo.Mouse do
  import Widget
  import Seagull

  def start() do
    f=frame :f, "This is frame", size: {700,200}, react: [:close] do
      box :vertical do
        box :horizontal do
          button :I, label: "This button reacts\non mouse down and up clicks.", react: [:mouse_left_down, :mouse_right_down,
            :mouse_middle_down, :mouse_left_up, :mouse_right_up, :mouse_middle_up]
          button :J, label: "This button reacts\non mouse entering\nand leaving it.", react: [:mouse_enter, :mouse_leave]
          button :N, label: "This button reacts\non mouse moving\nover it", react: [:mouse_move]
        end
        box :horizontal do
          button :O, label: "This button reacts\non mouse wheel.", react:  [:mouse_wheel]
          button :P, label: "This button reacts\non mouse double clicks", react: [:mouse_left_double_click,
            :mouse_right_double_click, :mouse_middle_double_click]
        end
      end
    end

    pid=WindowProcess.start f
    reaction pid
  end

  defp reaction(pid) do
    continue=true
    receive_event do
      from pid: ^pid do
        from widget: :f do
          :close->
            IO.puts "You closed frame."
            pid<-:destroy
            continue=false
          :mouse_left_down, {x, y}->
            IO.puts "You clicked on frame on position [#{x}, #{y}]."
        end
        from widget: :I do
          :mouse_left_down, {x, y}->IO.puts "Your left mouse button is down on position [#{x}, #{y}]."
          :mouse_right_down, {x, y}->IO.puts "Your right mouse button is down on position [#{x}, #{y}]."
          :mouse_middle_down, {x, y}->IO.puts "Your middle mouse button is down on position [#{x}, #{y}]."
          :mouse_left_up, {x, y}->IO.puts "Your left mouse button is up on position [#{x}, #{y}]."
          :mouse_right_up, {x, y}->IO.puts "Your right mouse button is up on position [#{x}, #{y}]."
          :mouse_middle_up, {x, y}->IO.puts "Your middle mouse button is up on position [#{x}, #{y}]."
        end
        from widget: :J do
          :mouse_enter, {x, y}->IO.puts "Your mouse entered button on position [#{x}, #{y}]"
          :mouse_leave, {x, y}->IO.puts "Your mouse left button on position [#{x}, #{y}]"
        end
        from widget: :N, do: (:mouse_move, {x, y}->IO.puts "Mouse moved to [#{x}, #{y}].")
        from widget: :O, do: (:mouse_wheel, direction->IO.puts "Mouse wheel goes #{if direction==:up, do: "up", else: "down"}.")
        from widget: :P do
          :mouse_left_double_click, {x, y}->IO.puts "You left double clicked on position [#{x}, #{y}]."
          :mouse_right_double_click, {x, y}->IO.puts "You right double clicked on position [#{x}, #{y}]."
          :mouse_middle_double_click, {x, y}->IO.puts "You middle double clicked on position [#{x}, #{y}]."
        end
      end
    end
    if continue, do: reaction pid
  end

end
