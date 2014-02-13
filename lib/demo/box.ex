defmodule Demo.Box do

  @moduledoc"Contains demos."

  import Widget
  import Seagull

  #
  # BOX DEMO
  #

  def start()do
    f=frame id: :main_frame, react: [:close], size: {700, 500} do
      box :vertical, id: :vbox do
        box :horizontal, id: :hbox do
          button id: :prepend_button, label: "Prepend button", react: [:click]
          button id: :append_button, label: "Append button", react: [:click]
          button id: :prepend_line_button, label: "Prepend line", react: [:click]
          button id: :append_line_button, label: "Append line", react: [:click]
        end
      end
    end

    pid=WindowProcess.spawn_gui f

    reaction pid

  end

  def reaction(pid)do
    continue=true
    receive_event do
      from pid: ^pid do
        from widget: :main_frame do
          :close->
            send pid, :destroy
            continue=false
        end
        from widget: :prepend_button, do: (:click->send(pid, :hbox, :prepend, button(label: "P")))
        from widget: :append_button,  do: (:click->send(pid, :hbox, :append, button(label: "A")))
        from widget: :prepend_line_button, do: (:click->send(pid, :vbox, :prepend, box(:horizontal, do: button(label: "PL"))))
        from widget: :append_line_button,  do: (:click->send(pid, :vbox, :append, box(:horizontal, do: button(label: "AL"))))
      end
    end
    if continue, do: reaction(pid)
  end

end
