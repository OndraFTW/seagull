defmodule Demo.TextBox do
  import Seagull
  import Widget

  def start() do
    f=frame id: :main_frame, size: {500,500}, react: [:close] do
      box :vertical do
        box :horizontal do
          text_box value: "Value", size: {100,100}, text_align: :left
          text_box value: "Value", size: {100,100}, text_align: :center
          text_box value: "Value", size: {100,100}, text_align: :right
        end
        box :horizontal do
          text_box id: :click_text_box, value: "Click on me.", react: [:mouse_left_up]
          text_box id: :aaa_text_box, value: "A"
          button id: :a_button, label: "Add a", react: [:click]
          button id: :clear_button, label: "Clear", react: [:click]
        end
        box :horizontal do
          text_box id: :count_box, size: {245, 33}, value: "You clicked on button: 0"
          button id: :count_button, label: "Click me", react: [:click]
          text_box value: "This text box cant be adited.", readonly: true
        end
        box :horizontal do
          text_box id: :left_box, react: [:update]
          text_box id: :right_box, react: [:enter_pressed]
        end
        box :horizontal do
          text_box multiline: true, size: {100, 100}, value: "This is\nmultiline\ntext box."
          text_box multiline: true, size: {100, 100}, value: "This text box dont wrap lines.", wrap: :dont
          text_box multiline: true, size: {100, 100}, value: "This text box wrap lines at any character.", wrap: :character
          text_box multiline: true, size: {100, 100}, value: "This text box wrap lines at word boundaries.", wrap: :word
          text_box multiline: true, size: {100, 100}, value: "This text box wrap lines at word boundaries or at any character if word is longer than window. This is the default.", wrap: :best
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
            send pid, :destroy
            continue=false
        end
        from widget: :click_text_box, do: (:mouse_left_up, _->IO.puts "You clicked on text box.")
        from widget: :a_button, do: (:click->send pid, :aaa_text_box, :append_text, "a")
        from widget: :clear_button, do: (:click->send pid, :aaa_text_box, :clear)
        from widget: :count_button do
          :click->
            text=send pid, :count_box, :get_value
            count=Regex.run(%r/[0-9]+/, text) |> List.first |> binary_to_integer
            count=count+1
            text=Regex.replace %r/([0-9]+)/, text, integer_to_binary(count)
            send pid, :count_box, :set_value, text
        end
        from widget: :left_box do
          :update, value->
            send pid, :right_box, :set_value, value
        end
        from widget: :right_box do
          :enter_pressed, value->
            send pid, :left_box, :set_value, value
        end
      end
    end
    if continue, do: reaction pid
  end

end
