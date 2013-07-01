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
          text_box :click_text_box, value: "Click on me.", react: [:mouse_left_up]
          text_box :aaa_text_box, value: "A"
          button :a_button, label: "Add a", react: [:click]
          button :clear_button, label: "Clear", react: [:click]
        end
        box :horizontal do
          text_box :count_box, size: {245, 33}, value: "You clicked on button: 0"
          button :count_button, label: "Click me", react: [:click]
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
        from widget: :click_text_box, do: (:mouse_left_up, _->IO.puts "You clicked on text box.")
        from widget: :a_button, do: (:click->send pid, :aaa_text_box, :append_text, "a")
        from widget: :clear_button, do: (:click->send pid, :aaa_text_box, :clear)
        from widget: :count_button do
          :click->
            text=send pid, :count_box, :get_value
            count=Regex.run(%r/[0-9]+/, text) |> Enum.first |> binary_to_integer
            count=count+1
            text=Regex.replace %r/([0-9]+)/, text, integer_to_binary(count)
            send pid, :count_box, :set_value, text
        end
      end
    end
    if continue, do: reaction pid
  end

end
