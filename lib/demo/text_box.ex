defmodule Demo.TextBox do
  import Seagull
  import Widget

  def start() do
    f=frame :main_frame, "Main frame", react: [:close] do
      box :vertical do
        box :horizontal do
          text_box :_, value: "Value", size: {100,100}, text_align: :left
          text_box :_, value: "Value", size: {100,100}, text_align: :center
          text_box :_, value: "Value", size: {100,100}, text_align: :right
        end
        box :horizontal do
          text_box :text_box, value: "Click on me.", react: [:mouse_left_up]
        end
      end
    end
    pid=WindowProcess.spawn f
    reaction pid
  end

  defp reaction(pid) do
    continue=true
    receive_event do
      from pid: ^pid do
        from widget: :main_frame do
          :close->
            pid<-:destroy
            continue=false
        end
        from widget: :text_box, do: (:mouse_left_up, _->IO.puts "You clicked on text box.")
      end
    end
    if continue, do: reaction pid
  end

end
